/* Copyright 2004-2005 Graeme Rocher
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.codehaus.groovy.grails.webflow.persistence;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.orm.hibernate4.SessionHolder;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.webflow.core.collection.AttributeMap;
import org.springframework.webflow.core.collection.MutableAttributeMap;
import org.springframework.webflow.definition.FlowDefinition;
import org.springframework.webflow.execution.FlowSession;
import org.springframework.webflow.execution.RequestContext;
import org.springframework.webflow.persistence.HibernateFlowExecutionListener;
import org.springframework.util.ClassUtils;

/**
 * Extends the HibernateFlowExecutionListener and doesn't bind a session if one is already present.
 *
 * @author Graeme Rocher
 * @since 1.0
 */
public class SessionAwareHibernateFlowExecutionListener extends HibernateFlowExecutionListener {

    private static final boolean hibernate3Present = ClassUtils.isPresent("org.hibernate.connection.ConnectionProvider", HibernateFlowExecutionListener.class.getClassLoader());

    private final Logger log = LoggerFactory.getLogger(getClass());

    private SessionFactory localSessionFactory;

    /**
     * Create a new Hibernate Flow Execution Listener using giving Hibernate session factory and transaction manager.
     *
     * @param sessionFactory     the session factory to use
     * @param transactionManager the transaction manager to drive transactions
     */
    public SessionAwareHibernateFlowExecutionListener(SessionFactory sessionFactory, PlatformTransactionManager transactionManager) {
        super(sessionFactory, transactionManager);
        this.localSessionFactory = sessionFactory;
    }

    @Override
    public void sessionStarting(RequestContext context, FlowSession session, MutableAttributeMap input) {
        if (!isSessionAlreadyBound()) {
            log.debug("sessionStarting: Binding Hibernate session to flow");
            super.sessionStarting(context, session, input);
        }
        else {
            log.debug("sessionStarting: Obtaining current Hibernate session");
            obtainCurrentSession(context);
        }
    }

    @Override
    public void sessionEnding(RequestContext context, FlowSession session, String outcome, MutableAttributeMap output) {
        final Session hibernateSession = getBoundHibernateSession(session);
        if (hibernateSession!= null && session.isRoot()) {
            log.debug("sessionEnding: Commit transaction and unbinding Hibernate session");
            super.sessionEnding(context, session, outcome, output);
        }
    }

    @Override
    public void resuming(RequestContext context) {
        if (!isSessionAlreadyBound()) {
            log.debug("resuming: Resumed flow, obtaining existing Hibernate session");
//            final FlowExecutionContext executionContext = context.getFlowExecutionContext();
//            if (executionContext.getActiveSession().getScope().get(PERSISTENCE_CONTEXT_ATTRIBUTE) != null) {
            super.resuming(context);
//            }
        }
        else {
            obtainCurrentSession(context);
        }
    }

    private boolean isSessionAlreadyBound() {
        return TransactionSynchronizationManager.hasResource(localSessionFactory);
    }

    @Override
    public void sessionEnded(RequestContext context, FlowSession session, String outcome, AttributeMap output) {
        if (isPersistenceContext(session.getDefinition()) && !isSessionAlreadyBound()) {
            super.sessionEnded(context, session, outcome, output);
        }
    }

    @Override
    public void paused(RequestContext context) {
        if (log.isDebugEnabled()) log.debug("paused: Disconnecting Hibernate session");
        super.paused(context);
    }

    private Session getBoundHibernateSession(FlowSession session) {
        return (Session) session.getScope().get(PERSISTENCE_CONTEXT_ATTRIBUTE);
    }

    private boolean isPersistenceContext(FlowDefinition flow) {
        return flow.getAttributes().contains(PERSISTENCE_CONTEXT_ATTRIBUTE);
    }

    private void obtainCurrentSession(RequestContext context) {
        MutableAttributeMap flowScope = context.getFlowScope();
        if (flowScope.get(PERSISTENCE_CONTEXT_ATTRIBUTE) != null) {
            return;
        }

        Session session = null;
        if (hibernate3Present) {
            org.springframework.orm.hibernate3.SessionHolder sessionHolder = (org.springframework.orm.hibernate3.SessionHolder) TransactionSynchronizationManager.getResource(localSessionFactory);
            if (sessionHolder != null) session = sessionHolder.getSession();
        } else {
            SessionHolder sessionHolder = (SessionHolder) TransactionSynchronizationManager.getResource(localSessionFactory);  
             if (sessionHolder != null) session = sessionHolder.getSession();
       }
       flowScope.put(PERSISTENCE_CONTEXT_ATTRIBUTE, session);
    }
}
