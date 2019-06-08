%{--
     jBilling - The Enterprise Open Source Billing System
   Copyright (C) 2003-2011 Enterprise jBilling Software Ltd. and Emiliano Conde

   This file is part of jbilling.
   
   jbilling is free software: you can redistribute it and/or modify
   it under the terms of the GNU Affero General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   jbilling is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Affero General Public License for more details.
   
   You should have received a copy of the GNU Affero General Public License
   along with jbilling.  If not, see <http://www.gnu.org/licenses/>.

 This source was modified by Web Data Technologies LLP (www.webdatatechnologies.in) since 15 Nov 2015.
You may download the latest source from webdataconsulting.github.io.

 
  --}%

<g:remoteLink controller="${controller}" action="${action}" id="${id}"
        params="${sortableParams(params: [partial: true, max: params.max,_eventId: eventId,  offset: params.offset], sort: sort, order: order, alias: alias) + searchParams ?: [:]}"
        update="${update}" method="${method}">
    ${body}
    <img src="${resource(dir: 'images', file: order ? 'arrows-' + order + '.gif' : 'arrows.gif')}" alt="sort"/>
</g:remoteLink>