package com.sapienter.jbilling.server.user.tasks;

import com.sapienter.jbilling.server.pluggableTask.admin.PluggableTaskWS;
import com.sapienter.jbilling.server.user.ContactWS;
import com.sapienter.jbilling.server.user.UserDTOEx;
import com.sapienter.jbilling.server.user.UserWS;
import com.sapienter.jbilling.server.util.ServerConstants;
import com.sapienter.jbilling.server.util.api.JbillingAPI;
import com.sapienter.jbilling.server.util.api.JbillingAPIFactory;
import org.apache.commons.lang.StringUtils;
import org.testng.annotations.*;

import static com.sapienter.jbilling.test.Asserts.*;
import static org.testng.AssertJUnit.*;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
/**
 * Test an external web service client
 *
 * TODO: Doesn't work from within tests... Event is not being processed when invoked through the remote API
 *
 * @author Brian Cowdery
 * @since 19-Aug-2012
 */
@Test(groups = { "integration", "task", "ws-client" })
public class NewContactWebServiceTaskTest {

    private static int EXAMPLE_WEBSERVICE_PLUGIN_TYPE_ID = 102;

    private JbillingAPI api;
    private Integer pluginId;

    @BeforeClass
    private void getAPI() throws Exception {
        api = JbillingAPIFactory.getAPI();
    }

    @BeforeMethod
    private void enablePlugin() {
        PluggableTaskWS plugin = new PluggableTaskWS();
        plugin.setTypeId(EXAMPLE_WEBSERVICE_PLUGIN_TYPE_ID);
        plugin.setProcessingOrder(99);

        pluginId = api.createPlugin(plugin);
    }

    @AfterMethod
    private void disablePlugin() {
        try {
            if (pluginId != null) {
                api.deletePlugin(pluginId);
            }
            pluginId = null;

        } catch (Exception e) {
            /* ignore */
        }
    }


    /**
     * Test that the webservice is invoked when a customer is created.
     *
     * The webservice should set the customer notes to some remotely retrieved data, in
     * this case, the current weather for the customers contact location.
     */
    @Test
    public void testCreateCustomer() throws Exception {
        UserWS user = new UserWS();
        user.setUserName("ws-client-test-" + System.currentTimeMillis());
        user.setPassword("P@ssword1");
        user.setLanguageId(1);
        user.setMainRoleId(5);
        user.setStatusId(UserDTOEx.STATUS_ACTIVE);
        user.setCurrencyId(1);

        ContactWS contact = new ContactWS();
        contact.setEmail("ws-client-test@jbilling.com");
        contact.setFirstName("WS Client");
        contact.setLastName("Test");

        user.setContact(contact);

        // create the user and save the contact
        Integer userId = api.createUser(user);
        user = api.getUserWS(userId);

        // validate that the customer notes are set
        assertTrue("Customer notes should be populated", StringUtils.isNotEmpty(user.getNotes()));

        // cleanup
        api.deleteUser(userId);
    }
}
