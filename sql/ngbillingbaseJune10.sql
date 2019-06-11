--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.13
-- Dumped by pg_dump version 9.5.13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_type (
    id integer NOT NULL,
    credit_limit numeric(22,10),
    invoice_design character varying(100),
    invoice_delivery_method_id integer,
    date_created timestamp without time zone,
    credit_notification_limit1 numeric(22,10),
    credit_notification_limit2 numeric(22,10),
    language_id integer,
    entity_id integer,
    currency_id integer,
    optlock integer NOT NULL,
    main_subscript_order_period_id integer NOT NULL,
    next_invoice_day_of_period integer NOT NULL,
    notification_ait_id integer
);


ALTER TABLE public.account_type OWNER TO postgres;

--
-- Name: account_type_price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_type_price (
    account_type_id integer NOT NULL,
    create_datetime timestamp without time zone NOT NULL,
    price_expiry_date date
);


ALTER TABLE public.account_type_price OWNER TO postgres;

--
-- Name: ach; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ach (
    id integer NOT NULL,
    user_id integer,
    aba_routing character varying(40) NOT NULL,
    bank_account character varying(60) NOT NULL,
    account_type integer NOT NULL,
    bank_name character varying(50) NOT NULL,
    account_name character varying(100) NOT NULL,
    optlock integer NOT NULL,
    gateway_key character varying(100)
);


ALTER TABLE public.ach OWNER TO postgres;

--
-- Name: ageing_entity_step; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ageing_entity_step (
    id integer NOT NULL,
    entity_id integer,
    status_id integer,
    days integer NOT NULL,
    optlock integer NOT NULL,
    retry_payment smallint DEFAULT 0 NOT NULL,
    suspend smallint DEFAULT 0 NOT NULL,
    send_notification smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.ageing_entity_step OWNER TO postgres;

--
-- Name: asset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset (
    id integer NOT NULL,
    identifier character varying(200) NOT NULL,
    create_datetime timestamp without time zone NOT NULL,
    status_id integer NOT NULL,
    entity_id integer,
    deleted integer NOT NULL,
    item_id integer NOT NULL,
    notes character varying(1000),
    optlock integer NOT NULL,
    group_id integer,
    order_line_id integer,
    global boolean DEFAULT false NOT NULL
);


ALTER TABLE public.asset OWNER TO postgres;

--
-- Name: asset_assignment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_assignment (
    id integer NOT NULL,
    asset_id integer NOT NULL,
    order_line_id integer NOT NULL,
    start_datetime timestamp without time zone NOT NULL,
    end_datetime timestamp without time zone
);


ALTER TABLE public.asset_assignment OWNER TO postgres;

--
-- Name: asset_entity_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_entity_map (
    asset_id integer NOT NULL,
    entity_id integer NOT NULL
);


ALTER TABLE public.asset_entity_map OWNER TO postgres;

--
-- Name: asset_meta_field_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_meta_field_map (
    asset_id integer NOT NULL,
    meta_field_value_id integer NOT NULL
);


ALTER TABLE public.asset_meta_field_map OWNER TO postgres;

--
-- Name: asset_reservation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_reservation (
    id integer NOT NULL,
    user_id integer NOT NULL,
    creator_user_id integer NOT NULL,
    asset_id integer NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.asset_reservation OWNER TO postgres;

--
-- Name: asset_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_status (
    id integer NOT NULL,
    item_type_id integer,
    is_default integer NOT NULL,
    is_order_saved integer NOT NULL,
    is_available integer NOT NULL,
    deleted integer NOT NULL,
    optlock integer NOT NULL,
    is_internal integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.asset_status OWNER TO postgres;

--
-- Name: asset_transition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_transition (
    id integer NOT NULL,
    create_datetime timestamp without time zone NOT NULL,
    previous_status_id integer,
    new_status_id integer NOT NULL,
    asset_id integer NOT NULL,
    user_id integer,
    assigned_to_id integer
);


ALTER TABLE public.asset_transition OWNER TO postgres;

--
-- Name: base_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.base_user (
    id integer NOT NULL,
    entity_id integer,
    password character varying(1024),
    deleted integer DEFAULT 0 NOT NULL,
    language_id integer,
    status_id integer,
    subscriber_status integer DEFAULT 1,
    currency_id integer,
    create_datetime timestamp without time zone NOT NULL,
    last_status_change timestamp without time zone,
    last_login timestamp without time zone,
    user_name character varying(50),
    failed_attempts integer DEFAULT 0 NOT NULL,
    optlock integer NOT NULL,
    change_password_date date,
    encryption_scheme integer NOT NULL,
    account_locked_time timestamp without time zone,
    account_disabled_date date
);


ALTER TABLE public.base_user OWNER TO postgres;

--
-- Name: batch_job_execution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.batch_job_execution (
    job_execution_id integer NOT NULL,
    version integer,
    job_instance_id integer NOT NULL,
    create_time timestamp without time zone NOT NULL,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    status character varying(10),
    exit_code character varying(100),
    exit_message character varying(2500),
    last_updated timestamp without time zone,
    job_configuration_location character varying(2500)
);


ALTER TABLE public.batch_job_execution OWNER TO postgres;

--
-- Name: batch_job_execution_context; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.batch_job_execution_context (
    job_execution_id bigint NOT NULL,
    short_context character varying(2500) NOT NULL,
    serialized_context text
);


ALTER TABLE public.batch_job_execution_context OWNER TO postgres;

--
-- Name: batch_job_execution_params; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.batch_job_execution_params (
    job_execution_id integer NOT NULL,
    type_cd character varying(6) NOT NULL,
    key_name character varying(100) NOT NULL,
    string_val character varying(250),
    date_val timestamp without time zone,
    long_val integer,
    double_val numeric(17,0),
    identifying character(1)
);


ALTER TABLE public.batch_job_execution_params OWNER TO postgres;

--
-- Name: batch_job_execution_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.batch_job_execution_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.batch_job_execution_seq OWNER TO postgres;

--
-- Name: batch_job_instance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.batch_job_instance (
    job_instance_id integer NOT NULL,
    version integer,
    job_name character varying(100) NOT NULL,
    job_key character varying(32) NOT NULL
);


ALTER TABLE public.batch_job_instance OWNER TO postgres;

--
-- Name: batch_job_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.batch_job_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.batch_job_seq OWNER TO postgres;

--
-- Name: batch_process_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.batch_process_info (
    id integer NOT NULL,
    process_id integer NOT NULL,
    job_execution_id integer NOT NULL,
    total_failed_users integer NOT NULL,
    total_successful_users integer NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.batch_process_info OWNER TO postgres;

--
-- Name: batch_step_execution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.batch_step_execution (
    step_execution_id integer NOT NULL,
    version integer NOT NULL,
    step_name character varying(100) NOT NULL,
    job_execution_id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    status character varying(10),
    commit_count integer,
    read_count integer,
    filter_count integer,
    write_count integer,
    read_skip_count integer,
    write_skip_count integer,
    process_skip_count integer,
    rollback_count integer,
    exit_code character varying(100),
    exit_message character varying(2500),
    last_updated timestamp without time zone
);


ALTER TABLE public.batch_step_execution OWNER TO postgres;

--
-- Name: batch_step_execution_context; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.batch_step_execution_context (
    step_execution_id integer NOT NULL,
    short_context character varying(2500) NOT NULL,
    serialized_context text
);


ALTER TABLE public.batch_step_execution_context OWNER TO postgres;

--
-- Name: batch_step_execution_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.batch_step_execution_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.batch_step_execution_seq OWNER TO postgres;

--
-- Name: billing_process; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.billing_process (
    id integer NOT NULL,
    entity_id integer NOT NULL,
    billing_date date NOT NULL,
    period_unit_id integer NOT NULL,
    period_value integer NOT NULL,
    is_review integer NOT NULL,
    paper_invoice_batch_id integer,
    retries_to_do integer DEFAULT 0 NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.billing_process OWNER TO postgres;

--
-- Name: billing_process_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.billing_process_configuration (
    id integer NOT NULL,
    entity_id integer,
    next_run_date date NOT NULL,
    generate_report integer NOT NULL,
    retries integer,
    days_for_retry integer,
    days_for_report integer,
    review_status integer NOT NULL,
    due_date_unit_id integer NOT NULL,
    due_date_value integer NOT NULL,
    df_fm integer,
    only_recurring integer DEFAULT 1 NOT NULL,
    invoice_date_process integer NOT NULL,
    optlock integer NOT NULL,
    maximum_periods integer DEFAULT 1 NOT NULL,
    auto_payment_application integer DEFAULT 0 NOT NULL,
    period_unit_id integer DEFAULT 1 NOT NULL,
    last_day_of_month boolean DEFAULT false NOT NULL,
    prorating_type character varying(50) DEFAULT 'PRORATING_AUTO_OFF'::character varying
);


ALTER TABLE public.billing_process_configuration OWNER TO postgres;

--
-- Name: billing_process_failed_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.billing_process_failed_user (
    id integer NOT NULL,
    batch_process_id integer NOT NULL,
    user_id integer NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.billing_process_failed_user OWNER TO postgres;

--
-- Name: blacklist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blacklist (
    id integer NOT NULL,
    entity_id integer NOT NULL,
    create_datetime timestamp without time zone NOT NULL,
    type integer NOT NULL,
    source integer NOT NULL,
    credit_card integer,
    credit_card_id integer,
    contact_id integer,
    user_id integer,
    optlock integer NOT NULL,
    meta_field_value_id integer
);


ALTER TABLE public.blacklist OWNER TO postgres;

--
-- Name: breadcrumb; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.breadcrumb (
    id integer NOT NULL,
    user_id integer NOT NULL,
    controller character varying(255) NOT NULL,
    action character varying(255),
    name character varying(255),
    object_id integer,
    version integer NOT NULL,
    description character varying(255)
);


ALTER TABLE public.breadcrumb OWNER TO postgres;

--
-- Name: cdrentries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cdrentries (
    id integer NOT NULL,
    accountcode character varying(20),
    src character varying(20),
    dst character varying(20),
    dcontext character varying(20),
    clid character varying(20),
    channel character varying(20),
    dstchannel character varying(20),
    lastapp character varying(20),
    lastdatat character varying(20),
    start_time timestamp without time zone,
    answer timestamp without time zone,
    end_time timestamp without time zone,
    duration integer,
    billsec integer,
    disposition character varying(20),
    amaflags character varying(20),
    userfield character varying(100),
    ts timestamp without time zone
);


ALTER TABLE public.cdrentries OWNER TO postgres;

--
-- Name: charge_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.charge_sessions (
    id integer NOT NULL,
    user_id integer,
    session_token character varying(150),
    ts_started timestamp without time zone,
    ts_last_access timestamp without time zone,
    carried_units numeric(22,10)
);


ALTER TABLE public.charge_sessions OWNER TO postgres;

--
-- Name: contact; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact (
    id integer NOT NULL,
    organization_name character varying(200),
    street_addres1 character varying(100),
    street_addres2 character varying(100),
    city character varying(50),
    state_province character varying(30),
    postal_code character varying(15),
    country_code character varying(2),
    last_name character varying(30),
    first_name character varying(30),
    person_initial character varying(5),
    person_title character varying(40),
    phone_country_code integer,
    phone_area_code integer,
    phone_phone_number character varying(20),
    fax_country_code integer,
    fax_area_code integer,
    fax_phone_number character varying(20),
    email character varying(200),
    create_datetime timestamp without time zone NOT NULL,
    deleted integer DEFAULT 0 NOT NULL,
    notification_include integer DEFAULT 1,
    user_id integer,
    optlock integer NOT NULL
);


ALTER TABLE public.contact OWNER TO postgres;

--
-- Name: contact_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_map (
    id integer NOT NULL,
    contact_id integer,
    table_id integer NOT NULL,
    foreign_id integer NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.contact_map OWNER TO postgres;

--
-- Name: country; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.country (
    id integer NOT NULL,
    code character varying(2) NOT NULL
);


ALTER TABLE public.country OWNER TO postgres;

--
-- Name: credit_card; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credit_card (
    id integer NOT NULL,
    cc_number character varying(100) NOT NULL,
    cc_number_plain character varying(20),
    cc_expiry date NOT NULL,
    name character varying(150),
    cc_type integer NOT NULL,
    deleted integer DEFAULT 0 NOT NULL,
    gateway_key character varying(100),
    optlock integer NOT NULL
);


ALTER TABLE public.credit_card OWNER TO postgres;

--
-- Name: currency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.currency (
    id integer NOT NULL,
    symbol character varying(10) NOT NULL,
    code character varying(3) NOT NULL,
    country_code character varying(2) NOT NULL,
    optlock integer
);


ALTER TABLE public.currency OWNER TO postgres;

--
-- Name: currency_entity_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.currency_entity_map (
    currency_id integer NOT NULL,
    entity_id integer NOT NULL
);


ALTER TABLE public.currency_entity_map OWNER TO postgres;

--
-- Name: currency_exchange; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.currency_exchange (
    id integer NOT NULL,
    entity_id integer,
    currency_id integer,
    rate numeric(22,10) NOT NULL,
    create_datetime timestamp without time zone NOT NULL,
    optlock integer NOT NULL,
    valid_since date DEFAULT '1970-01-01'::date NOT NULL
);


ALTER TABLE public.currency_exchange OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    id integer NOT NULL,
    user_id integer,
    partner_id integer,
    referral_fee_paid integer,
    invoice_delivery_method_id integer NOT NULL,
    auto_payment_type integer,
    due_date_unit_id integer,
    due_date_value integer,
    df_fm integer,
    parent_id integer,
    is_parent integer,
    exclude_aging integer DEFAULT 0 NOT NULL,
    invoice_child integer,
    optlock integer NOT NULL,
    dynamic_balance numeric(22,10),
    credit_limit numeric(22,10),
    auto_recharge numeric(22,10),
    use_parent_pricing boolean NOT NULL,
    main_subscript_order_period_id integer,
    next_invoice_day_of_period integer,
    next_inovice_date date,
    account_type_id integer,
    invoice_design character varying(100),
    credit_notification_limit1 numeric(22,10),
    credit_notification_limit2 numeric(22,10),
    recharge_threshold numeric(22,10),
    monthly_limit numeric(22,10),
    current_monthly_amount numeric(22,10),
    current_month timestamp without time zone
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_account_info_type_timeline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_account_info_type_timeline (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    account_info_type_id integer NOT NULL,
    meta_field_value_id integer NOT NULL,
    effective_date date NOT NULL
);


ALTER TABLE public.customer_account_info_type_timeline OWNER TO postgres;

--
-- Name: customer_meta_field_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_meta_field_map (
    customer_id integer NOT NULL,
    meta_field_value_id integer NOT NULL
);


ALTER TABLE public.customer_meta_field_map OWNER TO postgres;

--
-- Name: customer_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_notes (
    id integer NOT NULL,
    note_title character varying(50),
    note_content character varying(1000),
    creation_time timestamp without time zone,
    entity_id integer,
    user_id integer,
    customer_id integer
);


ALTER TABLE public.customer_notes OWNER TO postgres;

--
-- Name: data_table_query; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_table_query (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    route_id integer NOT NULL,
    global integer NOT NULL,
    root_entry_id integer NOT NULL,
    user_id integer NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.data_table_query OWNER TO postgres;

--
-- Name: data_table_query_entry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_table_query_entry (
    id integer NOT NULL,
    route_id integer NOT NULL,
    columns character varying(250) NOT NULL,
    next_entry_id integer,
    optlock integer NOT NULL
);


ALTER TABLE public.data_table_query_entry OWNER TO postgres;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20)
);


ALTER TABLE public.databasechangelog OWNER TO postgres;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO postgres;

--
-- Name: discount; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discount (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    discount_type character varying(25) NOT NULL,
    rate numeric(22,10),
    start_date date,
    end_date date,
    entity_id integer,
    last_update_datetime timestamp without time zone
);


ALTER TABLE public.discount OWNER TO postgres;

--
-- Name: discount_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discount_attribute (
    discount_id integer NOT NULL,
    attribute_name character varying(255) NOT NULL,
    attribute_value character varying(255)
);


ALTER TABLE public.discount_attribute OWNER TO postgres;

--
-- Name: discount_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discount_line (
    id integer NOT NULL,
    discount_id integer NOT NULL,
    item_id integer,
    order_id integer NOT NULL,
    discount_order_line_id integer,
    order_line_amount numeric(22,10),
    description character varying(1000) NOT NULL
);


ALTER TABLE public.discount_line OWNER TO postgres;

--
-- Name: discount_meta_field_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discount_meta_field_map (
    discount_id integer NOT NULL,
    meta_field_value_id integer NOT NULL
);


ALTER TABLE public.discount_meta_field_map OWNER TO postgres;

--
-- Name: entity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entity (
    id integer NOT NULL,
    external_id character varying(20),
    description character varying(100) NOT NULL,
    create_datetime timestamp without time zone NOT NULL,
    language_id integer NOT NULL,
    currency_id integer NOT NULL,
    optlock integer NOT NULL,
    deleted integer DEFAULT 0 NOT NULL,
    invoice_as_reseller boolean DEFAULT false NOT NULL,
    parent_id integer
);


ALTER TABLE public.entity OWNER TO postgres;

--
-- Name: entity_delivery_method_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entity_delivery_method_map (
    method_id integer NOT NULL,
    entity_id integer NOT NULL
);


ALTER TABLE public.entity_delivery_method_map OWNER TO postgres;

--
-- Name: entity_payment_method_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entity_payment_method_map (
    entity_id integer NOT NULL,
    payment_method_id integer NOT NULL
);


ALTER TABLE public.entity_payment_method_map OWNER TO postgres;

--
-- Name: entity_report_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entity_report_map (
    report_id integer NOT NULL,
    entity_id integer NOT NULL
);


ALTER TABLE public.entity_report_map OWNER TO postgres;

--
-- Name: enumeration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enumeration (
    id integer NOT NULL,
    entity_id integer NOT NULL,
    name character varying(50) NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.enumeration OWNER TO postgres;

--
-- Name: enumeration_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enumeration_values (
    id integer NOT NULL,
    enumeration_id integer NOT NULL,
    value character varying(50) NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.enumeration_values OWNER TO postgres;

--
-- Name: event_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_log (
    id integer NOT NULL,
    entity_id integer,
    user_id integer,
    table_id integer,
    foreign_id integer NOT NULL,
    create_datetime timestamp without time zone NOT NULL,
    level_field integer NOT NULL,
    module_id integer NOT NULL,
    message_id integer NOT NULL,
    old_num integer,
    old_str character varying(1000),
    old_date timestamp without time zone,
    optlock integer NOT NULL,
    affected_user_id integer
);


ALTER TABLE public.event_log OWNER TO postgres;

--
-- Name: event_log_message; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_log_message (
    id integer NOT NULL
);


ALTER TABLE public.event_log_message OWNER TO postgres;

--
-- Name: event_log_module; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_log_module (
    id integer NOT NULL
);


ALTER TABLE public.event_log_module OWNER TO postgres;

--
-- Name: filter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.filter (
    id integer NOT NULL,
    filter_set_id integer NOT NULL,
    type character varying(255) NOT NULL,
    constraint_type character varying(255) NOT NULL,
    field character varying(255) NOT NULL,
    template character varying(255) NOT NULL,
    visible boolean NOT NULL,
    integer_value integer,
    string_value character varying(255),
    start_date_value timestamp without time zone,
    end_date_value timestamp without time zone,
    version integer NOT NULL,
    boolean_value boolean,
    decimal_value numeric(22,10),
    decimal_high_value numeric(22,10),
    field_key_data character varying(255)
);


ALTER TABLE public.filter OWNER TO postgres;

--
-- Name: filter_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.filter_set (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    user_id integer NOT NULL,
    version integer NOT NULL
);


ALTER TABLE public.filter_set OWNER TO postgres;

--
-- Name: filter_set_filter_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.filter_set_filter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.filter_set_filter_id_seq OWNER TO postgres;

--
-- Name: filter_set_filter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.filter_set_filter (
    filter_set_filters_id integer,
    filter_id integer,
    id integer DEFAULT nextval('public.filter_set_filter_id_seq'::regclass)
);


ALTER TABLE public.filter_set_filter OWNER TO postgres;

--
-- Name: generic_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.generic_status (
    id integer NOT NULL,
    dtype character varying(50) NOT NULL,
    status_value integer NOT NULL,
    can_login integer,
    ordr integer,
    attribute1 character varying(20),
    entity_id integer,
    deleted integer
);


ALTER TABLE public.generic_status OWNER TO postgres;

--
-- Name: generic_status_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.generic_status_type (
    id character varying(50) NOT NULL
);


ALTER TABLE public.generic_status_type OWNER TO postgres;

--
-- Name: international_description; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.international_description (
    table_id integer NOT NULL,
    foreign_id integer NOT NULL,
    psudo_column character varying(20) NOT NULL,
    language_id integer NOT NULL,
    content character varying(4000) NOT NULL
);


ALTER TABLE public.international_description OWNER TO postgres;

--
-- Name: invoice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice (
    id integer NOT NULL,
    create_datetime timestamp without time zone NOT NULL,
    billing_process_id integer,
    user_id integer,
    delegated_invoice_id integer,
    due_date date NOT NULL,
    total numeric(22,10) NOT NULL,
    payment_attempts integer DEFAULT 0 NOT NULL,
    status_id integer DEFAULT 1 NOT NULL,
    balance numeric(22,10),
    carried_balance numeric(22,10) NOT NULL,
    in_process_payment integer DEFAULT 1 NOT NULL,
    is_review integer NOT NULL,
    currency_id integer NOT NULL,
    deleted integer DEFAULT 0 NOT NULL,
    paper_invoice_batch_id integer,
    customer_notes character varying(1000),
    public_number character varying(40),
    last_reminder date,
    overdue_step integer,
    create_timestamp timestamp without time zone NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.invoice OWNER TO postgres;

--
-- Name: invoice_commission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice_commission (
    id integer NOT NULL,
    partner_id integer,
    referral_partner_id integer,
    commission_process_run_id integer,
    invoice_id integer,
    standard_amount numeric(22,10),
    master_amount numeric(22,10),
    exception_amount numeric(22,10),
    referral_amount numeric(22,10),
    commission_id integer
);


ALTER TABLE public.invoice_commission OWNER TO postgres;

--
-- Name: invoice_delivery_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice_delivery_method (
    id integer NOT NULL
);


ALTER TABLE public.invoice_delivery_method OWNER TO postgres;

--
-- Name: invoice_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice_line (
    id integer NOT NULL,
    invoice_id integer,
    type_id integer,
    amount numeric(22,10) NOT NULL,
    quantity numeric(22,10),
    price numeric(22,10),
    deleted integer DEFAULT 0 NOT NULL,
    item_id integer,
    description character varying(1000),
    source_user_id integer,
    is_percentage integer DEFAULT 0 NOT NULL,
    optlock integer NOT NULL,
    order_id integer
);


ALTER TABLE public.invoice_line OWNER TO postgres;

--
-- Name: invoice_line_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice_line_type (
    id integer NOT NULL,
    description character varying(50) NOT NULL,
    order_position integer NOT NULL
);


ALTER TABLE public.invoice_line_type OWNER TO postgres;

--
-- Name: invoice_meta_field_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice_meta_field_map (
    invoice_id integer NOT NULL,
    meta_field_value_id integer NOT NULL
);


ALTER TABLE public.invoice_meta_field_map OWNER TO postgres;

--
-- Name: item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item (
    id integer NOT NULL,
    internal_number character varying(50),
    entity_id integer,
    deleted integer DEFAULT 0 NOT NULL,
    has_decimals integer DEFAULT 0 NOT NULL,
    optlock integer NOT NULL,
    gl_code character varying(50),
    price_manual integer,
    asset_management_enabled integer DEFAULT 0 NOT NULL,
    standard_availability boolean DEFAULT true NOT NULL,
    global boolean DEFAULT false NOT NULL,
    standard_partner_percentage numeric(22,10),
    master_partner_percentage numeric(22,10),
    active_since date,
    active_until date,
    reservation_duration integer DEFAULT 0 NOT NULL,
    percentage boolean DEFAULT false
);


ALTER TABLE public.item OWNER TO postgres;

--
-- Name: item_account_type_availability; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_account_type_availability (
    item_id integer,
    account_type_id integer
);


ALTER TABLE public.item_account_type_availability OWNER TO postgres;

--
-- Name: item_dependency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_dependency (
    id integer NOT NULL,
    dtype character varying(10) NOT NULL,
    item_id integer NOT NULL,
    min integer NOT NULL,
    max integer,
    dependent_item_id integer,
    dependent_item_type_id integer,
    period integer
);


ALTER TABLE public.item_dependency OWNER TO postgres;

--
-- Name: item_entity_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_entity_map (
    item_id integer NOT NULL,
    entity_id integer NOT NULL
);


ALTER TABLE public.item_entity_map OWNER TO postgres;

--
-- Name: item_meta_field_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_meta_field_map (
    item_id integer NOT NULL,
    meta_field_value_id integer NOT NULL
);


ALTER TABLE public.item_meta_field_map OWNER TO postgres;

--
-- Name: item_price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_price (
    id integer NOT NULL,
    item_id integer,
    currency_id integer,
    price numeric(22,10) NOT NULL,
    optlock integer NOT NULL,
    start_date timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL
);


ALTER TABLE public.item_price OWNER TO postgres;

--
-- Name: item_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_type (
    id integer NOT NULL,
    entity_id integer NOT NULL,
    description character varying(100),
    order_line_type_id integer NOT NULL,
    optlock integer NOT NULL,
    internal boolean NOT NULL,
    parent_id integer,
    allow_asset_management integer DEFAULT 0 NOT NULL,
    asset_identifier_label character varying(50),
    global boolean DEFAULT false NOT NULL,
    one_per_order boolean DEFAULT false NOT NULL,
    one_per_customer boolean DEFAULT false NOT NULL
);


ALTER TABLE public.item_type OWNER TO postgres;

--
-- Name: item_type_entity_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_type_entity_map (
    item_type_id integer NOT NULL,
    entity_id integer NOT NULL
);


ALTER TABLE public.item_type_entity_map OWNER TO postgres;

--
-- Name: item_type_exclude_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_type_exclude_map (
    item_id integer NOT NULL,
    type_id integer NOT NULL
);


ALTER TABLE public.item_type_exclude_map OWNER TO postgres;

--
-- Name: item_type_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_type_map (
    item_id integer NOT NULL,
    type_id integer NOT NULL
);


ALTER TABLE public.item_type_map OWNER TO postgres;

--
-- Name: item_type_meta_field_def_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_type_meta_field_def_map (
    item_type_id integer NOT NULL,
    meta_field_id integer NOT NULL
);


ALTER TABLE public.item_type_meta_field_def_map OWNER TO postgres;

--
-- Name: item_type_meta_field_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_type_meta_field_map (
    item_type_id integer NOT NULL,
    meta_field_value_id integer NOT NULL
);


ALTER TABLE public.item_type_meta_field_map OWNER TO postgres;

--
-- Name: jb_host_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jb_host_master (
    jb_version character(10),
    jb_allow_signup boolean DEFAULT true,
    jb_git_url character varying(256),
    jb_last_git_commit character(10) DEFAULT NULL::bpchar
);


ALTER TABLE public.jb_host_master OWNER TO postgres;

--
-- Name: jbilling_seqs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jbilling_seqs (
    name character varying(255) NOT NULL,
    next_id integer
);


ALTER TABLE public.jbilling_seqs OWNER TO postgres;

--
-- Name: jbilling_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jbilling_table (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.jbilling_table OWNER TO postgres;

--
-- Name: language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language (
    id integer NOT NULL,
    code character varying(2) NOT NULL,
    description character varying(50) NOT NULL
);


ALTER TABLE public.language OWNER TO postgres;

--
-- Name: list_meta_field_values_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.list_meta_field_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.list_meta_field_values_id_seq OWNER TO postgres;

--
-- Name: list_meta_field_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.list_meta_field_values (
    meta_field_value_id integer NOT NULL,
    list_value character varying(255),
    id integer DEFAULT nextval('public.list_meta_field_values_id_seq'::regclass)
);


ALTER TABLE public.list_meta_field_values OWNER TO postgres;

--
-- Name: matching_field; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matching_field (
    id integer NOT NULL,
    description character varying(255) NOT NULL,
    required boolean NOT NULL,
    route_id integer,
    matching_field character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    order_sequence integer NOT NULL,
    optlock integer NOT NULL,
    longest_value integer NOT NULL,
    smallest_value integer NOT NULL,
    mandatory_fields_query character varying(1000) NOT NULL
);


ALTER TABLE public.matching_field OWNER TO postgres;

--
-- Name: mediation_cfg; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mediation_cfg (
    id integer NOT NULL,
    entity_id integer NOT NULL,
    create_datetime timestamp without time zone NOT NULL,
    name character varying(50) NOT NULL,
    order_value integer NOT NULL,
    pluggable_task_id integer NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.mediation_cfg OWNER TO postgres;

--
-- Name: mediation_errors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mediation_errors (
    accountcode character varying(50) NOT NULL,
    src character varying(50),
    dst character varying(50),
    dcontext character varying(50),
    clid character varying(50),
    channel character varying(50),
    dstchannel character varying(50),
    lastapp character varying(50),
    lastdata character varying(50),
    start_time timestamp without time zone,
    answer timestamp without time zone,
    end_time timestamp without time zone,
    duration integer,
    billsec integer,
    disposition character varying(50),
    amaflags character varying(50),
    userfield character varying(50),
    error_message character varying(200),
    should_retry boolean
);


ALTER TABLE public.mediation_errors OWNER TO postgres;

--
-- Name: mediation_order_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mediation_order_map (
    mediation_process_id integer NOT NULL,
    order_id integer NOT NULL
);


ALTER TABLE public.mediation_order_map OWNER TO postgres;

--
-- Name: mediation_process; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mediation_process (
    id integer NOT NULL,
    configuration_id integer NOT NULL,
    start_datetime timestamp without time zone NOT NULL,
    end_datetime timestamp without time zone,
    orders_affected integer NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.mediation_process OWNER TO postgres;

--
-- Name: mediation_record; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mediation_record (
    id_key character varying(100) NOT NULL,
    start_datetime timestamp without time zone NOT NULL,
    mediation_process_id integer,
    optlock integer NOT NULL,
    status_id integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.mediation_record OWNER TO postgres;

--
-- Name: mediation_record_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mediation_record_line (
    id integer NOT NULL,
    order_line_id integer NOT NULL,
    event_date timestamp without time zone NOT NULL,
    amount numeric(22,10) NOT NULL,
    quantity numeric(22,10) NOT NULL,
    description character varying(200),
    optlock integer NOT NULL,
    mediation_record_id integer NOT NULL
);


ALTER TABLE public.mediation_record_line OWNER TO postgres;

--
-- Name: meta_field_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meta_field_group (
    id integer NOT NULL,
    date_created date,
    date_updated date,
    entity_id integer NOT NULL,
    display_order integer,
    optlock integer,
    entity_type character varying(32) NOT NULL,
    discriminator character varying(30) NOT NULL,
    name character varying(32),
    account_type_id integer
);


ALTER TABLE public.meta_field_group OWNER TO postgres;

--
-- Name: meta_field_name; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meta_field_name (
    id integer NOT NULL,
    name character varying(100),
    entity_type character varying(25) NOT NULL,
    data_type character varying(25) NOT NULL,
    is_disabled boolean,
    is_mandatory boolean,
    display_order integer,
    default_value_id integer,
    optlock integer NOT NULL,
    entity_id integer DEFAULT 1,
    error_message character varying(256),
    is_primary boolean DEFAULT true,
    validation_rule_id integer,
    filename character varying(100),
    field_usage character varying(50),
    is_unique boolean DEFAULT false NOT NULL
);


ALTER TABLE public.meta_field_name OWNER TO postgres;

--
-- Name: meta_field_value; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meta_field_value (
    id integer NOT NULL,
    meta_field_name_id integer NOT NULL,
    dtype character varying(10) NOT NULL,
    boolean_value boolean,
    date_value timestamp without time zone,
    decimal_value numeric(22,10),
    integer_value integer,
    string_value character varying(1000)
);


ALTER TABLE public.meta_field_value OWNER TO postgres;

--
-- Name: metafield_group_meta_field_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metafield_group_meta_field_map (
    metafield_group_id integer NOT NULL,
    meta_field_value_id integer NOT NULL
);


ALTER TABLE public.metafield_group_meta_field_map OWNER TO postgres;

--
-- Name: notification_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_category (
    id integer NOT NULL
);


ALTER TABLE public.notification_category OWNER TO postgres;

--
-- Name: notification_medium_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_medium_type (
    notification_id integer NOT NULL,
    medium_type character varying(255) NOT NULL
);


ALTER TABLE public.notification_medium_type OWNER TO postgres;

--
-- Name: notification_message; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_message (
    id integer NOT NULL,
    type_id integer,
    entity_id integer NOT NULL,
    language_id integer NOT NULL,
    use_flag integer DEFAULT 1 NOT NULL,
    optlock integer NOT NULL,
    attachment_type character varying(20),
    include_attachment integer,
    attachment_design character varying(100),
    notify_admin integer,
    notify_partner integer,
    notify_parent integer,
    notify_all_parents integer
);


ALTER TABLE public.notification_message OWNER TO postgres;

--
-- Name: notification_message_arch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_message_arch (
    id integer NOT NULL,
    type_id integer,
    create_datetime timestamp without time zone NOT NULL,
    user_id integer,
    result_message character varying(200),
    optlock integer NOT NULL
);


ALTER TABLE public.notification_message_arch OWNER TO postgres;

--
-- Name: notification_message_arch_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_message_arch_line (
    id integer NOT NULL,
    message_archive_id integer,
    section integer NOT NULL,
    content character varying(1000) NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.notification_message_arch_line OWNER TO postgres;

--
-- Name: notification_message_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_message_line (
    id integer NOT NULL,
    message_section_id integer,
    content character varying(1000) NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.notification_message_line OWNER TO postgres;

--
-- Name: notification_message_section; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_message_section (
    id integer NOT NULL,
    message_id integer,
    section integer,
    optlock integer NOT NULL
);


ALTER TABLE public.notification_message_section OWNER TO postgres;

--
-- Name: notification_message_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_message_type (
    id integer NOT NULL,
    optlock integer NOT NULL,
    category_id integer
);


ALTER TABLE public.notification_message_type OWNER TO postgres;

--
-- Name: order_billing_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_billing_type (
    id integer NOT NULL
);


ALTER TABLE public.order_billing_type OWNER TO postgres;

--
-- Name: order_change; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change (
    id integer NOT NULL,
    parent_order_change_id integer,
    parent_order_line_id integer,
    order_id integer NOT NULL,
    item_id integer NOT NULL,
    quantity numeric(22,10),
    price numeric(22,10),
    description character varying(1000),
    use_item integer,
    user_id integer NOT NULL,
    create_datetime timestamp without time zone NOT NULL,
    start_date date NOT NULL,
    application_date timestamp without time zone,
    status_id integer NOT NULL,
    user_assigned_status_id integer NOT NULL,
    order_line_id integer,
    optlock integer NOT NULL,
    error_message character varying(500),
    error_codes character varying(200),
    applied_manually integer,
    removal integer,
    next_billable_date date,
    end_date date,
    order_change_type_id integer NOT NULL,
    order_status_id integer,
    is_percentage boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_change OWNER TO postgres;

--
-- Name: order_change_asset_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change_asset_map (
    order_change_id integer NOT NULL,
    asset_id integer NOT NULL
);


ALTER TABLE public.order_change_asset_map OWNER TO postgres;

--
-- Name: order_change_meta_field_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change_meta_field_map (
    order_change_id integer NOT NULL,
    meta_field_value_id integer NOT NULL
);


ALTER TABLE public.order_change_meta_field_map OWNER TO postgres;

--
-- Name: order_change_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    entity_id integer,
    default_type boolean DEFAULT false NOT NULL,
    allow_order_status_change boolean DEFAULT false NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.order_change_type OWNER TO postgres;

--
-- Name: order_change_type_item_type_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change_type_item_type_map (
    order_change_type_id integer NOT NULL,
    item_type_id integer NOT NULL
);


ALTER TABLE public.order_change_type_item_type_map OWNER TO postgres;

--
-- Name: order_change_type_meta_field_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change_type_meta_field_map (
    order_change_type_id integer NOT NULL,
    meta_field_id integer NOT NULL
);


ALTER TABLE public.order_change_type_meta_field_map OWNER TO postgres;

--
-- Name: order_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line (
    id integer NOT NULL,
    order_id integer,
    item_id integer,
    type_id integer,
    amount numeric(22,10) NOT NULL,
    quantity numeric(22,10),
    price numeric(22,10),
    item_price integer,
    create_datetime timestamp without time zone NOT NULL,
    deleted integer DEFAULT 0 NOT NULL,
    description character varying(1000),
    optlock integer NOT NULL,
    use_item boolean NOT NULL,
    parent_line_id integer,
    start_date date,
    end_date date,
    sip_uri character varying(255),
    is_percentage boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_line OWNER TO postgres;

--
-- Name: order_line_meta_field_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_meta_field_map (
    order_line_id integer NOT NULL,
    meta_field_value_id integer NOT NULL
);


ALTER TABLE public.order_line_meta_field_map OWNER TO postgres;

--
-- Name: order_line_meta_fields_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_meta_fields_map (
    item_id integer NOT NULL,
    meta_field_id integer NOT NULL
);


ALTER TABLE public.order_line_meta_fields_map OWNER TO postgres;

--
-- Name: order_line_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_type (
    id integer NOT NULL,
    editable integer NOT NULL
);


ALTER TABLE public.order_line_type OWNER TO postgres;

--
-- Name: order_meta_field_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_meta_field_map (
    order_id integer NOT NULL,
    meta_field_value_id integer NOT NULL
);


ALTER TABLE public.order_meta_field_map OWNER TO postgres;

--
-- Name: order_period; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_period (
    id integer NOT NULL,
    entity_id integer,
    value integer,
    unit_id integer,
    optlock integer NOT NULL
);


ALTER TABLE public.order_period OWNER TO postgres;

--
-- Name: order_process; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_process (
    id integer NOT NULL,
    order_id integer,
    invoice_id integer,
    billing_process_id integer,
    periods_included integer,
    period_start date,
    period_end date,
    is_review integer NOT NULL,
    origin integer,
    optlock integer NOT NULL
);


ALTER TABLE public.order_process OWNER TO postgres;

--
-- Name: order_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_status (
    id integer NOT NULL,
    order_status_flag integer,
    entity_id integer
);


ALTER TABLE public.order_status OWNER TO postgres;

--
-- Name: paper_invoice_batch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paper_invoice_batch (
    id integer NOT NULL,
    total_invoices integer NOT NULL,
    delivery_date date,
    is_self_managed integer NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.paper_invoice_batch OWNER TO postgres;

--
-- Name: partner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.partner (
    id integer NOT NULL,
    user_id integer,
    total_payments numeric(22,10) NOT NULL,
    total_refunds numeric(22,10) NOT NULL,
    total_payouts numeric(22,10) NOT NULL,
    due_payout numeric(22,10),
    optlock integer NOT NULL,
    type character varying(250),
    parent_id integer,
    commission_type character varying(255)
);


ALTER TABLE public.partner OWNER TO postgres;

--
-- Name: partner_commission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.partner_commission (
    id integer NOT NULL,
    amount numeric(22,10),
    type character varying(255),
    partner_id integer,
    commission_process_run_id integer,
    currency_id integer
);


ALTER TABLE public.partner_commission OWNER TO postgres;

--
-- Name: partner_commission_exception; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.partner_commission_exception (
    id integer NOT NULL,
    partner_id integer,
    start_date date,
    end_date date,
    percentage numeric(22,10),
    item_id integer
);


ALTER TABLE public.partner_commission_exception OWNER TO postgres;

--
-- Name: partner_commission_proc_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.partner_commission_proc_config (
    id integer NOT NULL,
    entity_id integer,
    next_run_date date,
    period_unit_id integer,
    period_value integer
);


ALTER TABLE public.partner_commission_proc_config OWNER TO postgres;

--
-- Name: partner_commission_process_run; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.partner_commission_process_run (
    id integer NOT NULL,
    run_date date,
    period_start date,
    period_end date,
    entity_id integer
);


ALTER TABLE public.partner_commission_process_run OWNER TO postgres;

--
-- Name: partner_meta_field_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.partner_meta_field_map (
    partner_id integer NOT NULL,
    meta_field_value_id integer NOT NULL
);


ALTER TABLE public.partner_meta_field_map OWNER TO postgres;

--
-- Name: partner_payout; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.partner_payout (
    id integer NOT NULL,
    starting_date date NOT NULL,
    ending_date date NOT NULL,
    payments_amount numeric(22,10) NOT NULL,
    refunds_amount numeric(22,10) NOT NULL,
    balance_left numeric(22,10) NOT NULL,
    payment_id integer,
    partner_id integer,
    optlock integer NOT NULL
);


ALTER TABLE public.partner_payout OWNER TO postgres;

--
-- Name: partner_referral_commission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.partner_referral_commission (
    id integer NOT NULL,
    referral_id integer,
    referrer_id integer,
    start_date date,
    end_date date,
    percentage numeric(22,10)
);


ALTER TABLE public.partner_referral_commission OWNER TO postgres;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    id integer NOT NULL,
    user_id integer,
    attempt integer,
    result_id integer,
    amount numeric(22,10) NOT NULL,
    create_datetime timestamp without time zone NOT NULL,
    update_datetime timestamp without time zone,
    payment_date date,
    method_id integer,
    credit_card_id integer,
    deleted integer DEFAULT 0 NOT NULL,
    is_refund integer DEFAULT 0 NOT NULL,
    is_preauth integer DEFAULT 0 NOT NULL,
    payment_id integer,
    currency_id integer NOT NULL,
    payout_id integer,
    ach_id integer,
    balance numeric(22,10),
    optlock integer NOT NULL,
    payment_period integer,
    payment_notes character varying(500)
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: payment_authorization; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_authorization (
    id integer NOT NULL,
    payment_id integer,
    processor character varying(40) NOT NULL,
    code1 character varying(40) NOT NULL,
    code2 character varying(40),
    code3 character varying(40),
    approval_code character varying(20),
    avs character varying(20),
    transaction_id character varying(40),
    md5 character varying(100),
    card_code character varying(100),
    create_datetime date NOT NULL,
    response_message character varying(200),
    optlock integer NOT NULL
);


ALTER TABLE public.payment_authorization OWNER TO postgres;

--
-- Name: payment_commission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_commission (
    id integer NOT NULL,
    invoice_id integer,
    payment_amount numeric(22,10)
);


ALTER TABLE public.payment_commission OWNER TO postgres;

--
-- Name: payment_info_cheque; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_info_cheque (
    id integer NOT NULL,
    payment_id integer,
    bank character varying(50),
    cheque_number character varying(50),
    cheque_date date,
    optlock integer NOT NULL
);


ALTER TABLE public.payment_info_cheque OWNER TO postgres;

--
-- Name: payment_information; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_information (
    id integer NOT NULL,
    user_id integer,
    payment_method_id integer NOT NULL,
    processing_order integer,
    deleted integer NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.payment_information OWNER TO postgres;

--
-- Name: payment_information_meta_fields_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_information_meta_fields_map (
    payment_information_id integer NOT NULL,
    meta_field_value_id integer NOT NULL
);


ALTER TABLE public.payment_information_meta_fields_map OWNER TO postgres;

--
-- Name: payment_instrument_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_instrument_info (
    id integer NOT NULL,
    result_id integer NOT NULL,
    method_id integer NOT NULL,
    instrument_id integer NOT NULL,
    payment_id integer NOT NULL
);


ALTER TABLE public.payment_instrument_info OWNER TO postgres;

--
-- Name: payment_invoice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_invoice (
    id integer NOT NULL,
    payment_id integer,
    invoice_id integer,
    amount numeric(22,10),
    create_datetime timestamp without time zone NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.payment_invoice OWNER TO postgres;

--
-- Name: payment_meta_field_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_meta_field_map (
    payment_id integer NOT NULL,
    meta_field_value_id integer NOT NULL
);


ALTER TABLE public.payment_meta_field_map OWNER TO postgres;

--
-- Name: payment_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_method (
    id integer NOT NULL
);


ALTER TABLE public.payment_method OWNER TO postgres;

--
-- Name: payment_method_account_type_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_method_account_type_map (
    payment_method_id integer NOT NULL,
    account_type_id integer NOT NULL
);


ALTER TABLE public.payment_method_account_type_map OWNER TO postgres;

--
-- Name: payment_method_meta_fields_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_method_meta_fields_map (
    payment_method_id integer NOT NULL,
    meta_field_id integer NOT NULL
);


ALTER TABLE public.payment_method_meta_fields_map OWNER TO postgres;

--
-- Name: payment_method_template; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_method_template (
    id integer NOT NULL,
    template_name character varying(20) NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.payment_method_template OWNER TO postgres;

--
-- Name: payment_method_template_meta_fields_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_method_template_meta_fields_map (
    method_template_id integer NOT NULL,
    meta_field_id integer NOT NULL
);


ALTER TABLE public.payment_method_template_meta_fields_map OWNER TO postgres;

--
-- Name: payment_method_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_method_type (
    id integer NOT NULL,
    method_name character varying(20) NOT NULL,
    is_recurring boolean DEFAULT false NOT NULL,
    entity_id integer NOT NULL,
    template_id integer NOT NULL,
    optlock integer NOT NULL,
    all_account_type boolean DEFAULT false NOT NULL
);


ALTER TABLE public.payment_method_type OWNER TO postgres;

--
-- Name: payment_result; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_result (
    id integer NOT NULL
);


ALTER TABLE public.payment_result OWNER TO postgres;

--
-- Name: period_unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.period_unit (
    id integer NOT NULL
);


ALTER TABLE public.period_unit OWNER TO postgres;

--
-- Name: pluggable_task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pluggable_task (
    id integer NOT NULL,
    entity_id integer NOT NULL,
    type_id integer,
    processing_order integer NOT NULL,
    optlock integer NOT NULL,
    notes character varying(1000)
);


ALTER TABLE public.pluggable_task OWNER TO postgres;

--
-- Name: pluggable_task_parameter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pluggable_task_parameter (
    id integer NOT NULL,
    task_id integer,
    name character varying(50) NOT NULL,
    int_value integer,
    str_value character varying(500),
    float_value numeric(22,10),
    optlock integer NOT NULL
);


ALTER TABLE public.pluggable_task_parameter OWNER TO postgres;

--
-- Name: pluggable_task_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pluggable_task_type (
    id integer NOT NULL,
    category_id integer NOT NULL,
    class_name character varying(200) NOT NULL,
    min_parameters integer NOT NULL
);


ALTER TABLE public.pluggable_task_type OWNER TO postgres;

--
-- Name: pluggable_task_type_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pluggable_task_type_category (
    id integer NOT NULL,
    interface_name character varying(200) NOT NULL
);


ALTER TABLE public.pluggable_task_type_category OWNER TO postgres;

--
-- Name: preference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.preference (
    id integer NOT NULL,
    type_id integer,
    table_id integer NOT NULL,
    foreign_id integer NOT NULL,
    value character varying(200)
);


ALTER TABLE public.preference OWNER TO postgres;

--
-- Name: preference_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.preference_type (
    id integer NOT NULL,
    def_value character varying(200),
    validation_rule_id integer
);


ALTER TABLE public.preference_type OWNER TO postgres;

--
-- Name: process_run; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.process_run (
    id integer NOT NULL,
    process_id integer,
    run_date date NOT NULL,
    started timestamp without time zone NOT NULL,
    finished timestamp without time zone,
    payment_finished timestamp without time zone,
    invoices_generated integer,
    optlock integer NOT NULL,
    status_id integer NOT NULL
);


ALTER TABLE public.process_run OWNER TO postgres;

--
-- Name: process_run_total; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.process_run_total (
    id integer NOT NULL,
    process_run_id integer,
    currency_id integer NOT NULL,
    total_invoiced numeric(22,10),
    total_paid numeric(22,10),
    total_not_paid numeric(22,10),
    optlock integer NOT NULL
);


ALTER TABLE public.process_run_total OWNER TO postgres;

--
-- Name: process_run_total_pm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.process_run_total_pm (
    id integer NOT NULL,
    process_run_total_id integer,
    payment_method_id integer,
    total numeric(22,10) NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.process_run_total_pm OWNER TO postgres;

--
-- Name: process_run_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.process_run_user (
    id integer NOT NULL,
    process_run_id integer NOT NULL,
    user_id integer NOT NULL,
    status integer NOT NULL,
    created timestamp without time zone NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.process_run_user OWNER TO postgres;

--
-- Name: promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion (
    id integer NOT NULL,
    item_id integer,
    code character varying(50) NOT NULL,
    notes character varying(200),
    once integer NOT NULL,
    since date,
    until date
);


ALTER TABLE public.promotion OWNER TO postgres;

--
-- Name: promotion_user_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_user_map (
    user_id integer NOT NULL,
    promotion_id integer NOT NULL
);


ALTER TABLE public.promotion_user_map OWNER TO postgres;

--
-- Name: purchase_order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_order (
    id integer NOT NULL,
    user_id integer,
    period_id integer,
    billing_type_id integer NOT NULL,
    active_since date,
    active_until date,
    cycle_start date,
    create_datetime timestamp without time zone NOT NULL,
    next_billable_day date,
    created_by integer,
    status_id integer NOT NULL,
    currency_id integer NOT NULL,
    deleted integer DEFAULT 0 NOT NULL,
    notify integer,
    last_notified timestamp without time zone,
    notification_step integer,
    due_date_unit_id integer,
    due_date_value integer,
    df_fm integer,
    anticipate_periods integer,
    own_invoice integer,
    notes character varying(200),
    notes_in_invoice integer,
    optlock integer NOT NULL,
    primary_order_id integer,
    prorate_flag boolean DEFAULT false NOT NULL,
    parent_order_id integer,
    cancellation_fee_type character varying(50),
    cancellation_fee integer,
    cancellation_fee_percentage integer,
    cancellation_maximum_fee integer,
    cancellation_minimum_period integer,
    reseller_order integer,
    free_usage_quantity numeric(22,10),
    deleted_date date
);


ALTER TABLE public.purchase_order OWNER TO postgres;

--
-- Name: rating_unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rating_unit (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    entity_id integer NOT NULL,
    price_unit_name character varying(50),
    increment_unit_name character varying(50),
    increment_unit_quantity numeric(22,10),
    can_be_deleted boolean DEFAULT true,
    optlock integer NOT NULL
);


ALTER TABLE public.rating_unit OWNER TO postgres;

--
-- Name: recent_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recent_item (
    id integer NOT NULL,
    type character varying(255) NOT NULL,
    object_id integer NOT NULL,
    user_id integer NOT NULL,
    version integer NOT NULL
);


ALTER TABLE public.recent_item OWNER TO postgres;

--
-- Name: report; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report (
    id integer NOT NULL,
    type_id integer NOT NULL,
    name character varying(255) NOT NULL,
    file_name character varying(500) NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.report OWNER TO postgres;

--
-- Name: report_parameter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_parameter (
    id integer NOT NULL,
    report_id integer NOT NULL,
    dtype character varying(10) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.report_parameter OWNER TO postgres;

--
-- Name: report_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.report_type OWNER TO postgres;

--
-- Name: reseller_entityid_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reseller_entityid_map (
    entity_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.reseller_entityid_map OWNER TO postgres;

--
-- Name: reserved_amounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reserved_amounts (
    id integer NOT NULL,
    session_id integer,
    ts_created timestamp without time zone,
    currency_id integer,
    reserved_amount numeric(22,10),
    item_id integer,
    data text,
    quantity numeric(22,10)
);


ALTER TABLE public.reserved_amounts OWNER TO postgres;

--
-- Name: reset_password_code; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reset_password_code (
    base_user_id integer NOT NULL,
    date_created timestamp without time zone,
    token character varying(32) NOT NULL,
    new_password character varying(40)
);


ALTER TABLE public.reset_password_code OWNER TO postgres;

--
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role (
    id integer NOT NULL,
    entity_id integer,
    role_type_id integer
);


ALTER TABLE public.role OWNER TO postgres;

--
-- Name: route; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.route (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    table_name character varying(50) NOT NULL,
    entity_id integer NOT NULL,
    optlock integer NOT NULL,
    root_table boolean DEFAULT false,
    output_field_name character varying(150),
    default_route character varying(255),
    route_table boolean DEFAULT false
);


ALTER TABLE public.route OWNER TO postgres;

--
-- Name: shortcut; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shortcut (
    id integer NOT NULL,
    user_id integer NOT NULL,
    controller character varying(255) NOT NULL,
    action character varying(255),
    name character varying(255),
    object_id integer,
    version integer NOT NULL
);


ALTER TABLE public.shortcut OWNER TO postgres;

--
-- Name: sure_tax_txn_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sure_tax_txn_log (
    id integer NOT NULL,
    txn_id character varying(20) NOT NULL,
    txn_type character varying(10) NOT NULL,
    txn_data text NOT NULL,
    txn_date timestamp without time zone NOT NULL,
    resp_trans_id integer,
    request_type character varying(10)
);


ALTER TABLE public.sure_tax_txn_log OWNER TO postgres;

--
-- Name: tab; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tab (
    id integer NOT NULL,
    message_code character varying(50),
    controller_name character varying(50),
    access_url character varying(50),
    required_role character varying(50),
    version integer NOT NULL,
    default_order integer
);


ALTER TABLE public.tab OWNER TO postgres;

--
-- Name: tab_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tab_configuration (
    id integer NOT NULL,
    user_id integer,
    version integer NOT NULL
);


ALTER TABLE public.tab_configuration OWNER TO postgres;

--
-- Name: tab_configuration_tab; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tab_configuration_tab (
    id integer NOT NULL,
    tab_id integer,
    tab_configuration_id integer,
    display_order integer,
    visible boolean,
    version integer NOT NULL
);


ALTER TABLE public.tab_configuration_tab OWNER TO postgres;

--
-- Name: user_code; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_code (
    id integer NOT NULL,
    user_id integer NOT NULL,
    identifier character varying(55) NOT NULL,
    external_ref character varying(50),
    type character varying(50),
    type_desc character varying(250),
    valid_from date,
    valid_to date
);


ALTER TABLE public.user_code OWNER TO postgres;

--
-- Name: user_code_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_code_link (
    id integer NOT NULL,
    user_code_id integer NOT NULL,
    object_type character varying(50) NOT NULL,
    object_id integer
);


ALTER TABLE public.user_code_link OWNER TO postgres;

--
-- Name: user_credit_card_map_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_credit_card_map_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_credit_card_map_id_seq OWNER TO postgres;

--
-- Name: user_credit_card_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_credit_card_map (
    user_id integer,
    credit_card_id integer,
    id integer DEFAULT nextval('public.user_credit_card_map_id_seq'::regclass)
);


ALTER TABLE public.user_credit_card_map OWNER TO postgres;

--
-- Name: user_password_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_password_map (
    id integer NOT NULL,
    base_user_id integer NOT NULL,
    date_created timestamp without time zone NOT NULL,
    new_password character varying(1024) NOT NULL
);


ALTER TABLE public.user_password_map OWNER TO postgres;

--
-- Name: user_role_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_role_map (
    user_id integer NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE public.user_role_map OWNER TO postgres;

--
-- Name: user_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_status (
    id integer NOT NULL,
    can_login smallint
);


ALTER TABLE public.user_status OWNER TO postgres;

--
-- Name: validation_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.validation_rule (
    id integer NOT NULL,
    rule_type character varying(25) NOT NULL,
    enabled boolean,
    optlock integer NOT NULL
);


ALTER TABLE public.validation_rule OWNER TO postgres;

--
-- Name: validation_rule_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.validation_rule_attributes (
    validation_rule_id integer NOT NULL,
    attribute_name character varying(255) NOT NULL,
    attribute_value character varying(255)
);


ALTER TABLE public.validation_rule_attributes OWNER TO postgres;

--
-- Data for Name: account_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_type (id, credit_limit, invoice_design, invoice_delivery_method_id, date_created, credit_notification_limit1, credit_notification_limit2, language_id, entity_id, currency_id, optlock, main_subscript_order_period_id, next_invoice_day_of_period, notification_ait_id) FROM stdin;
100	100.0000000000		1	2016-11-13 21:49:48.493	100.0000000000	50.0000000000	1	10	1	2	100	1	10
101	0.0000000000	simple_invoice_b2b	1	2016-11-17 22:21:44.499	0.0000000000	0.0000000000	1	10	1	1	100	1	11
102	0.0000000000	simple_invoice_b2b	1	2016-11-17 23:38:52.016	0.0000000000	0.0000000000	1	10	1	1	100	1	14
\.


--
-- Data for Name: account_type_price; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_type_price (account_type_id, create_datetime, price_expiry_date) FROM stdin;
\.


--
-- Data for Name: ach; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ach (id, user_id, aba_routing, bank_account, account_type, bank_name, account_name, optlock, gateway_key) FROM stdin;
\.


--
-- Data for Name: ageing_entity_step; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ageing_entity_step (id, entity_id, status_id, days, optlock, retry_payment, suspend, send_notification) FROM stdin;
\.


--
-- Data for Name: asset; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset (id, identifier, create_datetime, status_id, entity_id, deleted, item_id, notes, optlock, group_id, order_line_id, global) FROM stdin;
\.


--
-- Data for Name: asset_assignment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_assignment (id, asset_id, order_line_id, start_datetime, end_datetime) FROM stdin;
\.


--
-- Data for Name: asset_entity_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_entity_map (asset_id, entity_id) FROM stdin;
\.


--
-- Data for Name: asset_meta_field_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_meta_field_map (asset_id, meta_field_value_id) FROM stdin;
\.


--
-- Data for Name: asset_reservation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_reservation (id, user_id, creator_user_id, asset_id, start_date, end_date, optlock) FROM stdin;
\.


--
-- Data for Name: asset_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_status (id, item_type_id, is_default, is_order_saved, is_available, deleted, optlock, is_internal) FROM stdin;
1	\N	0	0	0	0	1	1
100	200	1	0	1	0	0	0
101	200	0	0	0	0	0	0
102	200	0	1	0	0	0	0
\.


--
-- Data for Name: asset_transition; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_transition (id, create_datetime, previous_status_id, new_status_id, asset_id, user_id, assigned_to_id) FROM stdin;
\.


--
-- Data for Name: base_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.base_user (id, entity_id, password, deleted, language_id, status_id, subscriber_status, currency_id, create_datetime, last_status_change, last_login, user_name, failed_attempts, optlock, change_password_date, encryption_scheme, account_locked_time, account_disabled_date) FROM stdin;
10	10	$2a$10$SRTAryLzbrZ/KKG2tq2jGeEneOXg8Yb.kCxaL8lw//uE78jQ09y3O	0	1	1	9	1	2016-11-13 21:49:47.301	\N	2019-06-10 21:31:18.055	admin	0	19	2019-06-07	6	\N	\N
\.


--
-- Data for Name: batch_job_execution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.batch_job_execution (job_execution_id, version, job_instance_id, create_time, start_time, end_time, status, exit_code, exit_message, last_updated, job_configuration_location) FROM stdin;
\.


--
-- Data for Name: batch_job_execution_context; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.batch_job_execution_context (job_execution_id, short_context, serialized_context) FROM stdin;
\.


--
-- Data for Name: batch_job_execution_params; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.batch_job_execution_params (job_execution_id, type_cd, key_name, string_val, date_val, long_val, double_val, identifying) FROM stdin;
\.


--
-- Name: batch_job_execution_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.batch_job_execution_seq', 1, false);


--
-- Data for Name: batch_job_instance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.batch_job_instance (job_instance_id, version, job_name, job_key) FROM stdin;
\.


--
-- Name: batch_job_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.batch_job_seq', 1, false);


--
-- Data for Name: batch_process_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.batch_process_info (id, process_id, job_execution_id, total_failed_users, total_successful_users, optlock) FROM stdin;
\.


--
-- Data for Name: batch_step_execution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.batch_step_execution (step_execution_id, version, step_name, job_execution_id, start_time, end_time, status, commit_count, read_count, filter_count, write_count, read_skip_count, write_skip_count, process_skip_count, rollback_count, exit_code, exit_message, last_updated) FROM stdin;
\.


--
-- Data for Name: batch_step_execution_context; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.batch_step_execution_context (step_execution_id, short_context, serialized_context) FROM stdin;
\.


--
-- Name: batch_step_execution_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.batch_step_execution_seq', 1, false);


--
-- Data for Name: billing_process; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billing_process (id, entity_id, billing_date, period_unit_id, period_value, is_review, paper_invoice_batch_id, retries_to_do, optlock) FROM stdin;
\.


--
-- Data for Name: billing_process_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billing_process_configuration (id, entity_id, next_run_date, generate_report, retries, days_for_retry, days_for_report, review_status, due_date_unit_id, due_date_value, df_fm, only_recurring, invoice_date_process, optlock, maximum_periods, auto_payment_application, period_unit_id, last_day_of_month, prorating_type) FROM stdin;
100	10	2016-12-13	1	0	\N	3	1	1	1	\N	1	0	1	99	1	1	f	PRORATING_AUTO_ON
\.


--
-- Data for Name: billing_process_failed_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billing_process_failed_user (id, batch_process_id, user_id, optlock) FROM stdin;
\.


--
-- Data for Name: blacklist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blacklist (id, entity_id, create_datetime, type, source, credit_card, credit_card_id, contact_id, user_id, optlock, meta_field_value_id) FROM stdin;
\.


--
-- Data for Name: breadcrumb; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.breadcrumb (id, user_id, controller, action, name, object_id, version, description) FROM stdin;
91	10	customer	edit	create	\N	0	create
92	10	product	index	\N	\N	0	\N
93	10	product	editCategory	create	\N	0	create
94	10	product	list	\N	\N	0	\N
95	10	product	editCategory	create	\N	0	create
96	10	product	list	\N	200	0	\N
97	10	product	editProduct	create	\N	0	create
\.


--
-- Data for Name: cdrentries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cdrentries (id, accountcode, src, dst, dcontext, clid, channel, dstchannel, lastapp, lastdatat, start_time, answer, end_time, duration, billsec, disposition, amaflags, userfield, ts) FROM stdin;
\.


--
-- Data for Name: charge_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.charge_sessions (id, user_id, session_token, ts_started, ts_last_access, carried_units) FROM stdin;
\.


--
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact (id, organization_name, street_addres1, street_addres2, city, state_province, postal_code, country_code, last_name, first_name, person_initial, person_title, phone_country_code, phone_area_code, phone_phone_number, fax_country_code, fax_area_code, fax_phone_number, email, create_datetime, deleted, notification_include, user_id, optlock) FROM stdin;
100	ngecom	KOCHUPARAMBIL HOUSE	ERUVA P.O  ERUVA EAST	KAYAMKULAM .  ALLAPPUZHA Dist	KERALA	69056	IN	Sahadevan	Rakesh	\N	\N	971	50	508380660	\N	\N	\N	priyaviraj83@gmail.com	2016-11-13 21:49:47.018	0	\N	\N	0
101	ngecom	Amaritharayil	S.R.P.M P.O	Karunagappally,Kollam	KERALA	69039	IN	Sahadevan	Rakesh	\N	\N	971	50	3998788	\N	\N	\N	rksahadevan@gmail.com	2016-11-13 21:49:47.733	0	1	10	1
\.


--
-- Data for Name: contact_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact_map (id, contact_id, table_id, foreign_id, optlock) FROM stdin;
100	100	5	10	0
101	101	10	10	0
\.


--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.country (id, code) FROM stdin;
1	AF
2	AL
3	DZ
4	AS
5	AD
6	AO
7	AI
8	AQ
9	AG
10	AR
11	AM
12	AW
13	AU
14	AT
15	AZ
16	BS
17	BH
18	BD
19	BB
20	BY
21	BE
22	BZ
23	BJ
24	BM
25	BT
26	BO
27	BA
28	BW
29	BV
30	BR
31	IO
32	BN
33	BG
34	BF
35	BI
36	KH
37	CM
38	CA
39	CV
40	KY
41	CF
42	TD
43	CL
44	CN
45	CX
46	CC
47	CO
48	KM
49	CG
50	CK
51	CR
52	CI
53	HR
54	CU
55	CY
56	CZ
57	CD
58	DK
59	DJ
60	DM
61	DO
62	TP
63	EC
64	EG
65	SV
66	GQ
67	ER
68	EE
69	ET
70	FK
71	FO
72	FJ
73	FI
74	FR
75	GF
76	PF
77	TF
78	GA
79	GM
80	GE
81	DE
82	GH
83	GI
84	GR
85	GL
86	GD
87	GP
88	GU
89	GT
90	GN
91	GW
92	GY
93	HT
94	HM
95	HN
96	HK
97	HU
98	IS
99	IN
100	ID
101	IR
102	IQ
103	IE
104	IL
105	IT
106	JM
107	JP
108	JO
109	KZ
110	KE
111	KI
112	KR
113	KW
114	KG
115	LA
116	LV
117	LB
118	LS
119	LR
120	LY
121	LI
122	LT
123	LU
124	MO
125	MK
126	MG
127	MW
128	MY
129	MV
130	ML
131	MT
132	MH
133	MQ
134	MR
135	MU
136	YT
137	MX
138	FM
139	MD
140	MC
141	MN
142	MS
143	MA
144	MZ
145	MM
146	NA
147	NR
148	NP
149	NL
150	AN
151	NC
152	NZ
153	NI
154	NE
155	NG
156	NU
157	NF
158	KP
159	MP
160	NO
161	OM
162	PK
163	PW
164	PA
165	PG
166	PY
167	PE
168	PH
169	PN
170	PL
171	PT
172	PR
173	QA
174	RE
175	RO
176	RU
177	RW
178	WS
179	SM
180	ST
181	SA
182	SN
183	YU
184	SC
185	SL
186	SG
187	SK
188	SI
189	SB
190	SO
191	ZA
192	GS
193	ES
194	LK
195	SH
196	KN
197	LC
198	PM
199	VC
200	SD
201	SR
202	SJ
203	SZ
204	SE
205	CH
206	SY
207	TW
208	TJ
209	TZ
210	TH
211	TG
212	TK
213	TO
214	TT
215	TN
216	TR
217	TM
218	TC
219	TV
220	UG
221	UA
222	AE
223	UK
224	US
225	UM
226	UY
227	UZ
228	VU
229	VA
230	VE
231	VN
232	VG
233	VI
234	WF
235	YE
236	ZM
237	ZW
\.


--
-- Data for Name: credit_card; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credit_card (id, cc_number, cc_number_plain, cc_expiry, name, cc_type, deleted, gateway_key, optlock) FROM stdin;
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.currency (id, symbol, code, country_code, optlock) FROM stdin;
2	C$	CAD	CA	0
3	&#8364;	EUR	EU	0
4	&#165;	JPY	JP	0
5	&#163;	GBP	UK	0
6	&#8361;	KRW	KR	0
7	Sf	CHF	CH	0
8	SeK	SEK	SE	0
9	S$	SGD	SG	0
10	M$	MYR	MY	0
11	$	AUD	AU	0
12	₹	INR	IN	0
13	¥	CNY	CN	0
1	US$	USD	US	1
\.


--
-- Data for Name: currency_entity_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.currency_entity_map (currency_id, entity_id) FROM stdin;
1	10
\.


--
-- Data for Name: currency_exchange; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.currency_exchange (id, entity_id, currency_id, rate, create_datetime, optlock, valid_since) FROM stdin;
1	0	2	1.3250000000	2004-03-09 00:00:00	1	1970-01-01
2	0	3	0.8118000000	2004-03-09 00:00:00	1	1970-01-01
3	0	4	111.4000000000	2004-03-09 00:00:00	1	1970-01-01
4	0	5	0.5479000000	2004-03-09 00:00:00	1	1970-01-01
5	0	6	1171.0000000000	2004-03-09 00:00:00	1	1970-01-01
6	0	7	1.2300000000	2004-07-06 00:00:00	1	1970-01-01
7	0	8	7.4700000000	2004-07-06 00:00:00	1	1970-01-01
10	0	9	1.6800000000	2004-10-12 00:00:00	1	1970-01-01
11	0	10	3.8000000000	2004-10-12 00:00:00	1	1970-01-01
12	0	11	1.2880000000	2007-01-25 00:00:00	1	1970-01-01
13	0	12	66.7431996993	2015-12-10 00:00:00	1	1970-01-01
14	0	13	10.3706269649	2015-12-10 00:00:00	1	1970-01-01
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (id, user_id, partner_id, referral_fee_paid, invoice_delivery_method_id, auto_payment_type, due_date_unit_id, due_date_value, df_fm, parent_id, is_parent, exclude_aging, invoice_child, optlock, dynamic_balance, credit_limit, auto_recharge, use_parent_pricing, main_subscript_order_period_id, next_invoice_day_of_period, next_inovice_date, account_type_id, invoice_design, credit_notification_limit1, credit_notification_limit2, recharge_threshold, monthly_limit, current_monthly_amount, current_month) FROM stdin;
\.


--
-- Data for Name: customer_account_info_type_timeline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_account_info_type_timeline (id, customer_id, account_info_type_id, meta_field_value_id, effective_date) FROM stdin;
\.


--
-- Data for Name: customer_meta_field_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_meta_field_map (customer_id, meta_field_value_id) FROM stdin;
\.


--
-- Data for Name: customer_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_notes (id, note_title, note_content, creation_time, entity_id, user_id, customer_id) FROM stdin;
\.


--
-- Data for Name: data_table_query; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.data_table_query (id, name, route_id, global, root_entry_id, user_id, optlock) FROM stdin;
\.


--
-- Data for Name: data_table_query_entry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.data_table_query_entry (id, route_id, columns, next_entry_id, optlock) FROM stdin;
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase) FROM stdin;
1337623084753-1	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:48.527403	1	EXECUTED	7:8922bfebfc70cb70fd4684f82e90ecc0	createTable		\N	3.2.2
1337623084753-2	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:48.619413	2	EXECUTED	7:4543e51971682f746629b64f60f25424	createTable		\N	3.2.2
1337623084753-3	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:48.695155	3	EXECUTED	7:58002b5f2f43d673944e6db319c95e25	createTable		\N	3.2.2
1337623084753-4	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:48.779711	4	EXECUTED	7:65e4f1f41f33afa3af2aaf9f11fe894a	createTable		\N	3.2.2
1337623084753-5	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:48.895846	5	EXECUTED	7:f5069e51fd697b6062afaf2f78e5ecbb	createTable		\N	3.2.2
1337623084753-6	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:48.968268	6	EXECUTED	7:76ea4196cc9ae7f5e4b05d5b2e905b45	createTable		\N	3.2.2
1337623084753-7	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:49.091904	7	EXECUTED	7:1c468637211181df1494d3c2fffde1df	createTable		\N	3.2.2
1337623084753-9	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:49.227539	8	EXECUTED	7:485c707222e5a3a59e85a58dc72deaa8	createTable		\N	3.2.2
1337623084753-10	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:49.315467	9	EXECUTED	7:2475e48c7730001b948dc413a3673707	createTable		\N	3.2.2
1337623084753-11	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:49.424308	10	EXECUTED	7:0714008a0e79b913249812348bd92812	createTable		\N	3.2.2
1337623084753-12	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:49.505786	11	EXECUTED	7:a22dc68a8e1cc035fc8e6b98c243afa2	createTable		\N	3.2.2
1337623084753-13	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:49.581261	12	EXECUTED	7:91dad5ca3c80ba7f0c86cd403ad1f5a1	createTable		\N	3.2.2
1337623084753-14	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:49.670844	13	EXECUTED	7:bb023c716e85f3e5a6ecc18addf74c93	createTable		\N	3.2.2
1337623084753-15	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:49.686662	14	EXECUTED	7:b3dc34c78a6d99215bd55e3cf9f024a5	createTable		\N	3.2.2
1337623084753-16	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:49.77085	15	EXECUTED	7:ccbc91b77accf90af85fe7a7f1e8eb50	createTable		\N	3.2.2
1337623084753-17	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:49.903146	16	EXECUTED	7:eeaa643a00b54017268d1f7d2d685561	createTable		\N	3.2.2
1337623084753-18	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:49.917967	17	EXECUTED	7:b86cc87b63206be74e0bf0810603b4b9	createTable		\N	3.2.2
1337623084753-20	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:50.002469	18	EXECUTED	7:875167c97cb7a74f69518cce3669b6bf	createTable		\N	3.2.2
1337623084753-21	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:50.017046	19	EXECUTED	7:e3a0537c1e4c52573487d9a174ea5868	createTable		\N	3.2.2
1337623084753-22	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:50.03356	20	EXECUTED	7:ad866e4480035e2d3611d758b1aae457	createTable		\N	3.2.2
1337623084753-23	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:50.050565	21	EXECUTED	7:4a31d34d4f9622f1d949707fd6f5af9a	createTable		\N	3.2.2
1337623084753-24	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:50.167314	22	EXECUTED	7:841d8cd76ebe7329c4a5eb65f1b75215	createTable		\N	3.2.2
1337623084753-25	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:50.241602	23	EXECUTED	7:d069497f8f0f4d5633a95960dae1c927	createTable		\N	3.2.2
1337623084753-26	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:50.375694	24	EXECUTED	7:b72e670cb94ade1967424839e713c7a6	createTable		\N	3.2.2
1337623084753-27	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:50.465655	25	EXECUTED	7:f0321e258497e2fcbf1837269cf57697	createTable		\N	3.2.2
1337623084753-28	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:50.553981	26	EXECUTED	7:9ac47f41854098201d8e3327bab3aaa9	createTable		\N	3.2.2
1337623084753-29	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:50.695987	27	EXECUTED	7:9a6a68eac5722813ddb11fb3f5b5c7cf	createTable		\N	3.2.2
1337623084753-30	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:50.770423	28	EXECUTED	7:c5ff89ba8a44fa1d04755fbe4d9aaba0	createTable		\N	3.2.2
1337623084753-31	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:50.785296	29	EXECUTED	7:f08d28a18f9bd6f14e882e433112d7c8	createTable		\N	3.2.2
1337623084753-32	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:50.861163	30	EXECUTED	7:df80d416e3a998ec1c9367b6a150e910	createTable		\N	3.2.2
1337623084753-33	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:50.935562	31	EXECUTED	7:3e5399c547a512022ed5924ab230808c	createTable		\N	3.2.2
1337623084753-34	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:51.053022	32	EXECUTED	7:4de2c4d22bbb5f42b88b5c865fab7eb6	createTable		\N	3.2.2
1337623084753-35	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:51.207782	33	EXECUTED	7:07262c39b56be415cf7c37fe63d42a69	createTable		\N	3.2.2
1337623084753-36	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:51.323945	34	EXECUTED	7:3b091de78f648afe18f9e9ad3e66413d	createTable		\N	3.2.2
1337623084753-37	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:51.465063	35	EXECUTED	7:ed8dd86cf5fbfb408f6181aedc2cfca8	createTable		\N	3.2.2
1337623084753-38	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:51.553643	36	EXECUTED	7:0fcd69c5133c7417e57410ad49c90c14	createTable		\N	3.2.2
1337623084753-39	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:51.569986	37	EXECUTED	7:0cf8dfbe640acc6dbc3bc62c3a90561b	createTable		\N	3.2.2
1337623084753-40	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:51.652618	38	EXECUTED	7:1caca3a71ad2afbd8ccd8f830215c6a9	createTable		\N	3.2.2
1337623084753-41	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:51.693941	39	EXECUTED	7:aefc2c13166967dbade6e629788be8f8	createTable		\N	3.2.2
1337623084753-43	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:51.769082	40	EXECUTED	7:78fa99c7075e71184d35caa2a64e1323	createTable		\N	3.2.2
1337623084753-44	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:51.784995	41	EXECUTED	7:e71d4833b5fd6f8c33fb4afdac2f6602	createTable		\N	3.2.2
1337623084753-45	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:51.83452	42	EXECUTED	7:dd8d274a4d158e81346dd07dbae9e4dc	createTable		\N	3.2.2
1337623084753-46	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:51.850983	43	EXECUTED	7:b27b564b5e45ff66688f7b59be7da0ae	createTable		\N	3.2.2
1337623084753-47	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:51.93213	44	EXECUTED	7:fd1da3e1a613390da6c9c50de7ec8dd1	createTable		\N	3.2.2
1337623084753-48	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:52.025783	45	EXECUTED	7:28e24c30a1fcf81bd315d1cc66162b5b	createTable		\N	3.2.2
1337623084753-49	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:52.040935	46	EXECUTED	7:dff7780f47c39c01843ce852439b56b2	createTable		\N	3.2.2
1337623084753-56	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:52.14009	47	EXECUTED	7:cfeb764e680a99849337a34ac178dbc7	createTable		\N	3.2.2
1337623084753-57	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:52.214906	48	EXECUTED	7:c3c22ccb5d4b12a2fea500373e60d062	createTable		\N	3.2.2
1337623084753-58	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:52.288742	49	EXECUTED	7:13d5847e8c5ad95b0fc5726d373c88fb	createTable		\N	3.2.2
1337623084753-59	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:52.363193	50	EXECUTED	7:4198e76fefd9fa386fb430303d822a67	createTable		\N	3.2.2
1337623084753-60	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:52.437133	51	EXECUTED	7:fc642db573ffdc1e618a3c8687842080	createTable		\N	3.2.2
1337623084753-61	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:52.54572	52	EXECUTED	7:83b1023dfb24225ce9a2d81c5b42bc83	createTable		\N	3.2.2
1337623084753-62	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:52.661424	53	EXECUTED	7:73cbcc198f3501f7806a785f3d209bbc	createTable		\N	3.2.2
1337623084753-63	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:52.728317	54	EXECUTED	7:d74efc0344146b6b79f3b7a2c1fd379f	createTable		\N	3.2.2
1337623084753-64	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:52.794516	55	EXECUTED	7:a7df71b28261768069a3b4b85f9c8eee	createTable		\N	3.2.2
1337623084753-65	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:52.860444	56	EXECUTED	7:cf70309e8abd8b593c5de9baf45167fa	createTable		\N	3.2.2
1337623084753-66	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:52.959987	57	EXECUTED	7:bd24286b5bd6410a6e61920a11d9864b	createTable		\N	3.2.2
1337623084753-67	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:53.050594	58	EXECUTED	7:25caddd42f70cd1fb8578934ce32151a	createTable		\N	3.2.2
1337623084753-68	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:53.066692	59	EXECUTED	7:ba7faa6025e643508a1356a016a5441a	createTable		\N	3.2.2
1337623084753-69	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:53.141595	60	EXECUTED	7:4f304ef3ad2349533a4bf8dcccdf81c4	createTable		\N	3.2.2
1337623084753-70	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:53.216551	61	EXECUTED	7:e9a90e7c10705101a981030ce0a5d182	createTable		\N	3.2.2
1337623084753-71	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:53.314548	62	EXECUTED	7:d6f47d891ec3566bf5fa9d0781164aaf	createTable		\N	3.2.2
1337623084753-72	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:53.390048	63	EXECUTED	7:8bb31b2fcc7078088b1d9549003c7542	createTable		\N	3.2.2
1337623084753-73	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:53.421917	64	EXECUTED	7:d9572ef7e927f18157afd29cd88599f4	createTable		\N	3.2.2
1337623084753-74	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:53.504587	65	EXECUTED	7:d3b6218392df92ad908a3c93b13d283f	createTable		\N	3.2.2
1337623084753-75	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:53.57951	66	EXECUTED	7:53b048b2daaae2527524683fa9370126	createTable		\N	3.2.2
1337623084753-76	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:53.713898	67	EXECUTED	7:1dcd25aebd541861664bb25e6a95aeb5	createTable		\N	3.2.2
1337623084753-77	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:53.852258	68	EXECUTED	7:8cc0b8eb3dc4c57bca43fb74fe8ba9f6	createTable		\N	3.2.2
1337623084753-78	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:53.942627	69	EXECUTED	7:faf64042497651dbe58fca13b595121c	createTable		\N	3.2.2
1337623084753-79	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:54.015654	70	EXECUTED	7:8d8395b59d4135177e3e97152321c39d	createTable		\N	3.2.2
1337623084753-80	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:54.031943	71	EXECUTED	7:9c176496b9d4502ce7931395f35bc44a	createTable		\N	3.2.2
1337623084753-81	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:54.097803	72	EXECUTED	7:f8806b3d1ca780622b4dfec350732459	createTable		\N	3.2.2
1337623084753-82	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:54.164027	73	EXECUTED	7:5a5559ed5e9105e545520f786702ba41	createTable		\N	3.2.2
1337623084753-83	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:54.238489	74	EXECUTED	7:48f296de8c91d93c6051f5aee0cccf03	createTable		\N	3.2.2
1337623084753-92	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:54.387136	75	EXECUTED	7:7a0fe4fd689496a88bec4d08ea2d14ee	createTable		\N	3.2.2
1337623084753-93	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:54.504472	76	EXECUTED	7:c730a0ddbcc43ae41d0d171037197776	createTable		\N	3.2.2
1337623084753-94	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:54.569939	77	EXECUTED	7:eb876cba9f2fec2d625d99cce58529a9	createTable		\N	3.2.2
1337623084753-95	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:54.643905	78	EXECUTED	7:cc69581564adc173b25c8c4e03690842	createTable		\N	3.2.2
1337623084753-96	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:54.719753	79	EXECUTED	7:35f4c7e4a908c1ef59be622b6c33ace8	createTable		\N	3.2.2
1337623084753-97	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:54.785402	80	EXECUTED	7:37490816ce942e643a637c26331286fa	createTable		\N	3.2.2
1337623084753-100	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:54.861688	81	EXECUTED	7:9205df323f2c15c685ed06f9f4491eab	createTable		\N	3.2.2
1337623084753-101	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:54.960205	82	EXECUTED	7:0c5a94d1f3378394d68b44396f4d1e43	createTable		\N	3.2.2
1337623084753-102	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:55.051532	83	EXECUTED	7:42bdcdfcead0d065149cad55681524c0	createTable		\N	3.2.2
1337623084753-103	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:55.1271	84	EXECUTED	7:c08d47ebd7356606e269e4a327170596	createTable		\N	3.2.2
1337623084753-104	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:55.207981	85	EXECUTED	7:b461b8cf0707edf2c94478c7c2d794e0	createTable		\N	3.2.2
1337623084753-105	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:55.223369	86	EXECUTED	7:ace973ecfbf315e6d3f82bd53dc0b477	createTable		\N	3.2.2
1337623084753-106	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:55.316248	87	EXECUTED	7:e3de9bcdddb0cc988d7610d2a1a00b32	createTable		\N	3.2.2
1337623084753-108	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:55.38109	88	EXECUTED	7:a68dac8b48dc6f65ff2dea5770001986	createTable		\N	3.2.2
1337623084753-109	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:55.480595	89	EXECUTED	7:af705ddba5368bd508b083effb1cfb82	createTable		\N	3.2.2
1337623084753-110	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:55.563745	90	EXECUTED	7:826d2988bdefbd37d26bbb65d9fc1108	createTable		\N	3.2.2
1337623084753-111	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:55.645106	91	EXECUTED	7:50d7aa6e39cc87396f27d68615c8d50c	createTable		\N	3.2.2
1337623084753-112	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:55.735898	92	EXECUTED	7:1f7885410869f4615dac1e1d07cff696	createTable		\N	3.2.2
1337623084753-113	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:55.835541	93	EXECUTED	7:d2a95b4dfdcbd8b9a73ca63ff5e345d0	createTable		\N	3.2.2
1337623084753-114	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:55.852199	94	EXECUTED	7:5f78d6ae3f31a54c849af6522260a069	createTable		\N	3.2.2
1337623084753-115	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:55.867633	95	EXECUTED	7:07c7b1f6224b8988f6f3e8ad0e8c047e	createTable		\N	3.2.2
1337623084753-319	Mahesh Shivarkar	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:55.934743	96	EXECUTED	7:8d8f703ad7dacac3ebcbd47e68eedec0	createTable		\N	3.2.2
1337623084753-117	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:56.524836	97	EXECUTED	7:87e9550f859e966dec9d281cdfc1dd48	addPrimaryKey		\N	3.2.2
1337623084753-119	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:56.636686	98	EXECUTED	7:f1c2782ad773845b19553e79f3dc5391	addPrimaryKey		\N	3.2.2
1337623084753-123	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:56.718187	99	EXECUTED	7:52309a419b3950177c73af5949f47005	addUniqueConstraint		\N	3.2.2
1337623084753-275	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:56.806965	100	EXECUTED	7:c2686f9acf46dd4643804f0a81082846	createIndex		\N	3.2.2
1337623084753-276	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:56.888982	101	EXECUTED	7:d7c7866adc8d375251789a69edb20467	createIndex		\N	3.2.2
1337623084753-277	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:56.979988	102	EXECUTED	7:cc67f9419e6ef2dcc2bbe073d6b6b9de	createIndex		\N	3.2.2
1337623084753-278	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:57.059419	103	EXECUTED	7:1727b1798178b0ffffff18a67f5a6867	createIndex		\N	3.2.2
1337623084753-279	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:57.148442	104	EXECUTED	7:f0f3154cbeec62c6ccb10d1a8343e62d	createIndex		\N	3.2.2
1337623084753-280	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:57.242037	105	EXECUTED	7:13a830711e5f414436fb33a1ad519e42	createIndex		\N	3.2.2
1337623084753-281	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:57.33472	106	EXECUTED	7:d987b9fbc745b67acc8e9a32e96aea70	createIndex		\N	3.2.2
1337623084753-282	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:57.421823	107	EXECUTED	7:3d28edff13be5e4423c26486379c6f31	createIndex		\N	3.2.2
1337623084753-283	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:57.535807	108	EXECUTED	7:6372c28e52eed7014b5bde10a28cf251	createIndex		\N	3.2.2
1337623084753-284	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:57.751101	109	EXECUTED	7:01c0d61a65dc8b722bd648b6dc482e0a	createIndex		\N	3.2.2
1337623084753-285	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:57.825726	110	EXECUTED	7:0596149a2dc329fb8b9b4f98ae54ac49	createIndex		\N	3.2.2
1337623084753-286	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:57.89004	111	EXECUTED	7:011eb535742a8d00970f215048f2e125	createIndex		\N	3.2.2
1337623084753-287	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:57.966685	112	EXECUTED	7:a6b890a6877ebeda60c8f84a60b4a89f	createIndex		\N	3.2.2
1337623084753-288	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:58.059412	113	EXECUTED	7:433d0a908a559a67d282e419687a1e4d	createIndex		\N	3.2.2
1337623084753-289	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:58.15623	114	EXECUTED	7:579e254c79923e01621b59846f089e29	createIndex		\N	3.2.2
1337623084753-290	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:58.258186	115	EXECUTED	7:379c46ff8b1b0fac4db10022e6ca8f33	createIndex		\N	3.2.2
1337623084753-291	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:58.347099	116	EXECUTED	7:dff786eb144e47a9499fba98377131e4	createIndex		\N	3.2.2
1337623084753-292	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:58.440485	117	EXECUTED	7:31f0f76bd0a1c9473d28095b3658667d	createIndex		\N	3.2.2
1337623084753-293	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:58.531428	118	EXECUTED	7:055ef896d9761d0d49de010db685c5a6	createIndex		\N	3.2.2
1337623084753-294	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:58.62843	119	EXECUTED	7:a32d1fd84eb1c7b88823b5c7cab181c6	createIndex		\N	3.2.2
1337623084753-295	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:58.718572	120	EXECUTED	7:11975e32cbfcd912b4b1bf2dbd8c779b	createIndex		\N	3.2.2
1337623084753-296	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:58.810869	121	EXECUTED	7:424bd03aa3aa1646b793f863fe253558	createIndex		\N	3.2.2
1337623084753-298	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:58.898568	122	EXECUTED	7:b4212acd1e65f02d3087997ca0330c10	createIndex		\N	3.2.2
1337623084753-299	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:58.982395	123	EXECUTED	7:20828164f60f1229ca1505ece7c2fc85	createIndex		\N	3.2.2
1337623084753-300	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:59.07407	124	EXECUTED	7:d6728c6bf7bb9dd186588af165a2dbaf	createIndex		\N	3.2.2
1337623084753-301	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:59.146791	125	EXECUTED	7:e69e0236869430e4fbb47d9588f13541	createIndex		\N	3.2.2
1337623084753-302	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:59.239785	126	EXECUTED	7:69ff6e381675605c0c160f3099e7bb87	createIndex		\N	3.2.2
1337623084753-303	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:59.330206	127	EXECUTED	7:e537aeb410d8893d88eb5510e2fe0075	createIndex		\N	3.2.2
1337623084753-304	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:59.418792	128	EXECUTED	7:2e5779c6ca114f02133ea1e248061cdd	createIndex		\N	3.2.2
1337623084753-305	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:59.501383	129	EXECUTED	7:b0f88448f336a132cc2d4ba0da17b797	createIndex		\N	3.2.2
1337623084753-306	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:59.569688	130	EXECUTED	7:2f8061b9e79a61c46232286ebf3acd81	createIndex		\N	3.2.2
1337623084753-310	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:59.675398	131	EXECUTED	7:3bbb241087ab9de6bea8468c2690e9c8	createIndex		\N	3.2.2
1337623084753-311	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:59.756876	132	EXECUTED	7:3f79c343ef2321709d4918093a2e00b4	createIndex		\N	3.2.2
1337623084753-312	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:59.885169	133	EXECUTED	7:06085b0f16fc1e534a141f5df2ccbf50	createIndex		\N	3.2.2
1337623084753-313	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 20:59:59.984241	134	EXECUTED	7:051124011bcc345dfd247fe6f1bb0b98	createIndex		\N	3.2.2
1337623084753-314	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:00.074778	135	EXECUTED	7:872164576f404bd25d2e1aacac05048b	createIndex		\N	3.2.2
1337623084753-315	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:00.156644	136	EXECUTED	7:dcf50778ee2fc38371c76339adf703a4	createIndex		\N	3.2.2
1337623084753-316	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:00.229513	137	EXECUTED	7:77a38d8be0387955425076e143f63cb2	createIndex		\N	3.2.2
1337623084753-317	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:00.302275	138	EXECUTED	7:dbc868040f1429f41108777e8f88a6cb	createIndex		\N	3.2.2
20120530-#2825-Fix-percentage-products-in-Plans	Juan Vidal	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:00.361154	139	EXECUTED	7:59fa33cc692b00665d419b4848aaf91c	insert (x2)		\N	3.2.2
1337972683141-1	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.312819	140	EXECUTED	7:892b03dadc233acca2db7ec13f101c85	insert (x3)		\N	3.2.2
1337972683141-2	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.347771	141	EXECUTED	7:fa9c382ea1b19e50f152621cb197c200	insert (x4)		\N	3.2.2
1337972683141-3	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.363976	142	EXECUTED	7:f886238981f23b68d125e8b28549baec	insert		\N	3.2.2
1337972683141-4	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.443019	143	EXECUTED	7:97ded74d9eedc78b89fb935c72d16c55	insert (x83)		\N	3.2.2
1337972683141-5	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.479441	144	EXECUTED	7:143fed48a07ca57c1daceb6153602a88	insert (x4)		\N	3.2.2
1337972683141-8	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.495398	145	EXECUTED	7:d43b88bf94e8b3c8f4062eb2a6fc7f94	insert (x5)		\N	3.2.2
1337972683141-9	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.532613	146	EXECUTED	7:8a0707eaf545f2e38d11839b42c8f12b	insert (x20)		\N	3.2.2
1337972683141-10	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.553399	147	EXECUTED	7:b80f83026687ae7d0d1375e6c26a20f1	insert (x4)		\N	3.2.2
1337972683141-11	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.609678	148	EXECUTED	7:e7b708ef395bc6dd9f9182435ed4188d	insert (x80)		\N	3.2.2
1337972683141-12	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.636017	149	EXECUTED	7:b903c29c915d7d299113ad0d4e61d824	insert (x2)		\N	3.2.2
1337972683141-13	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.652425	150	EXECUTED	7:f7a782164e04f7b3f15d629567ce768d	insert (x2)		\N	3.2.2
1337972683141-14	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.760351	151	EXECUTED	7:4a46f7ce9e8137ec22ed274f4ecfebfa	insert (x237)		\N	3.2.2
1337972683141-15	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.793048	152	EXECUTED	7:87037e224619b9533ce9439b6f1a1a06	insert (x4)		\N	3.2.2
1337972683141-16	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.819063	153	EXECUTED	7:b7d69d8fff2530a2f1de1a7cb15f716e	insert (x11)		\N	3.2.2
1337972683141-18	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.844148	154	EXECUTED	7:fe0ae9a150a7d52b241b3c985f08fe87	insert (x11)		\N	3.2.2
1337972683141-19	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.859293	155	EXECUTED	7:c8c6f8a9710886e7afc788b605cb9334	insert (x6)		\N	3.2.2
1337972683141-20	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.894648	156	EXECUTED	7:82e0c8279a94a8a793dbd80504fd1926	insert (x34)		\N	3.2.2
1337972683141-21	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.944687	157	EXECUTED	7:14fb39b005d5c3342b044d602b33f89c	insert (x74)		\N	3.2.2
1337972683141-22	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.974975	158	EXECUTED	7:1109e20657343a92a7125e944a3fc388	insert (x9)		\N	3.2.2
1337972683141-23	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:01.991048	159	EXECUTED	7:164fb555c85034315a8989521b5f5b12	insert (x3)		\N	3.2.2
1337972683141-24	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:02.007738	160	EXECUTED	7:79edf8a3a5506853f064eb79bd1bb30a	insert		\N	3.2.2
1337972683141-25	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:02.024325	161	EXECUTED	7:6681820783c4b007b05a8a91bcec3da3	insert (x4)		\N	3.2.2
1337972683141-26	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:02.050491	162	EXECUTED	7:587d53226acce3a9ddddd2471e6b4492	insert (x18)		\N	3.2.2
1337972683141-27	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:02.095139	163	EXECUTED	7:289e035c8f1e23c982cfab688581c87e	insert (x45)		\N	3.2.2
1337972683141-28	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:02.136028	164	EXECUTED	7:eadba725b9996268cc5b7acda1fd8012	insert (x10)		\N	3.2.2
1337972683141-29	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:02.165137	165	EXECUTED	7:21c89970a65dd49d28d95da673e6e328	insert (x15)		\N	3.2.2
1337972683141-30	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:02.192176	166	EXECUTED	7:466725d303d2465d862b3a7d6a440c51	insert (x18)		\N	3.2.2
1337972683141-31	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:02.226598	167	EXECUTED	7:ea46f4ee8be7507c55bfeddceb274a72	insert (x25)		\N	3.2.2
1337972683141-32	aristokrates (generated)	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:02.747543	168	EXECUTED	7:c8e2d0e46f2d65b6615edb152c54c078	insert (x1067)		\N	3.2.2
#14049-French and German Translation Texts	Manisha Gupta	descriptors/database/jbilling-init_data.xml	2016-11-13 21:00:03.219341	169	EXECUTED	7:dd6d45fab927aac247b1c011ab789ef4	insert (x2), sql		\N	3.2.2
1337623084753-126	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:03.742577	170	EXECUTED	7:75a4458852605f08e980823b5f9006ab	addForeignKeyConstraint		\N	3.2.2
1337623084753-127	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:03.760371	171	EXECUTED	7:5f2ce32f0fb8497611f789eac19f99f1	addForeignKeyConstraint		\N	3.2.2
1337623084753-128	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:03.775623	172	EXECUTED	7:e673d72b62e0b22b635bee51da2289d9	addForeignKeyConstraint		\N	3.2.2
1337623084753-129	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:03.792392	173	EXECUTED	7:b97de99f9ba546281e8562bd7e21cff6	addForeignKeyConstraint		\N	3.2.2
1337623084753-130	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:03.808865	174	EXECUTED	7:d2aee44b966453cd7b6c53627329350e	addForeignKeyConstraint		\N	3.2.2
1337623084753-131	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:03.825547	175	EXECUTED	7:1cd30f95824988b0117aa5bf311e5356	addForeignKeyConstraint		\N	3.2.2
1337623084753-132	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:03.842165	176	EXECUTED	7:74305f78440d940e59ad1c67ceed861e	addForeignKeyConstraint		\N	3.2.2
1337623084753-133	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:03.85851	177	EXECUTED	7:814576f082018486e8363af201bab961	addForeignKeyConstraint		\N	3.2.2
1337623084753-134	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:03.88412	178	EXECUTED	7:3f1504236ed54fe5131c6177c970fa0c	addForeignKeyConstraint		\N	3.2.2
1337623084753-135	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:03.900207	179	EXECUTED	7:4c23adfc033faf802947f6592ea77891	addForeignKeyConstraint		\N	3.2.2
1337623084753-136	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:03.916602	180	EXECUTED	7:c5df405e06b4187a05748d0b4f59630d	addForeignKeyConstraint		\N	3.2.2
1337623084753-137	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:03.933386	181	EXECUTED	7:60be39df8fdbb0ddc081fbebe8c54b64	addForeignKeyConstraint		\N	3.2.2
1337623084753-138	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:03.94981	182	EXECUTED	7:8806a5a1135003ff02aa0eb2d69a704b	addForeignKeyConstraint		\N	3.2.2
1337623084753-139	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:03.9664	183	EXECUTED	7:70b7422a6eff32b27fb9fe08e9e45217	addForeignKeyConstraint		\N	3.2.2
1337623084753-140	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:03.984012	184	EXECUTED	7:0ea2224088b851ccf69dafb3afee7e40	addForeignKeyConstraint		\N	3.2.2
1337623084753-141	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.000751	185	EXECUTED	7:76ba18fb2bebb05f411d0531bd7e6c8e	addForeignKeyConstraint		\N	3.2.2
1337623084753-142	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.016363	186	EXECUTED	7:1ed5930e3268ad94fba96e21fdea1249	addForeignKeyConstraint		\N	3.2.2
1337623084753-143	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.032716	187	EXECUTED	7:04d4799989743cd5704499e274368b2b	addForeignKeyConstraint		\N	3.2.2
1337623084753-144	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.049355	188	EXECUTED	7:4c73be0bc45aaf334bcf63c573e938cb	addForeignKeyConstraint		\N	3.2.2
1337623084753-145	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.06579	189	EXECUTED	7:e6b0f05a91612c4b440b5f99a8c0ea50	addForeignKeyConstraint		\N	3.2.2
1337623084753-146	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.082602	190	EXECUTED	7:7b3dcbcd8269799b4b0c8fa9bd09bec4	addForeignKeyConstraint		\N	3.2.2
1337623084753-147	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.099059	191	EXECUTED	7:d558528ecd03f62b1e9e338f59bf5d56	addForeignKeyConstraint		\N	3.2.2
1337623084753-148	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.115967	192	EXECUTED	7:6f46f0b755b98fde27e472d096d40a2a	addForeignKeyConstraint		\N	3.2.2
1337623084753-149	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.132969	193	EXECUTED	7:33fa4ce421c443142f0287ef168f0fbb	addForeignKeyConstraint		\N	3.2.2
1337623084753-150	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.181681	194	EXECUTED	7:0da342a911166e62660c407d77c3bd5a	addForeignKeyConstraint		\N	3.2.2
1337623084753-153	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.19832	195	EXECUTED	7:b827b4302366b9c807f81366a68e0de4	addForeignKeyConstraint		\N	3.2.2
1337623084753-154	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.2155	196	EXECUTED	7:b7ad5cb6690e13eb64461b5a98dbdf53	addForeignKeyConstraint		\N	3.2.2
1337623084753-155	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.232055	197	EXECUTED	7:05fbf423084f303b0d367b0737430e6c	addForeignKeyConstraint		\N	3.2.2
1337623084753-156	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.247983	198	EXECUTED	7:bf67b3134da20eb6268a3e97d1d9081c	addForeignKeyConstraint		\N	3.2.2
1337623084753-157	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.264367	199	EXECUTED	7:a27db18ae366812b1e64968d629573c3	addForeignKeyConstraint		\N	3.2.2
1337623084753-158	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.280944	200	EXECUTED	7:c94b05a44d2d7df27e2ac602046c7887	addForeignKeyConstraint		\N	3.2.2
1337623084753-159	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.29755	201	EXECUTED	7:368aee5dd0f38f4a77f2542debc79054	addForeignKeyConstraint		\N	3.2.2
1337623084753-160	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.314446	202	EXECUTED	7:f8b376c9402563d5e4bbea8e8f8ba9c4	addForeignKeyConstraint		\N	3.2.2
1337623084753-161	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.331517	203	EXECUTED	7:7e0038d684ebf592939a347817ab97da	addForeignKeyConstraint		\N	3.2.2
1337623084753-162	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.347004	204	EXECUTED	7:1acb6f8b10f87a06b38717d675d9a6b9	addForeignKeyConstraint		\N	3.2.2
1337623084753-163	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.364169	205	EXECUTED	7:4d42cbc89214b0789261d5b38054d506	addForeignKeyConstraint		\N	3.2.2
1337623084753-164	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.380971	206	EXECUTED	7:40a8bb1b37873c28120d3dd4aa282157	addForeignKeyConstraint		\N	3.2.2
1337623084753-165	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.397359	207	EXECUTED	7:9ac531852fc3f7cd0837aa589faa582e	addForeignKeyConstraint		\N	3.2.2
1337623084753-166	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.414302	208	EXECUTED	7:3004d4c9e496d94c854f76ea48c0076d	addForeignKeyConstraint		\N	3.2.2
1337623084753-167	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.43043	209	EXECUTED	7:63a2ef8480517cbdb4087901ced6188d	addForeignKeyConstraint		\N	3.2.2
1337623084753-168	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.445888	210	EXECUTED	7:aba5c2cf49fee6f01873e796c6105418	addForeignKeyConstraint		\N	3.2.2
1337623084753-169	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.47074	211	EXECUTED	7:79f8a3d295ad88ab7b517cb8ee83c692	addForeignKeyConstraint		\N	3.2.2
1337623084753-170	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.487255	212	EXECUTED	7:c1310382bb7ec369d5f26c0eb1fbb667	addForeignKeyConstraint		\N	3.2.2
1337623084753-171	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.503846	213	EXECUTED	7:cf1dcec7874b07a0ad7e15f99b027a0b	addForeignKeyConstraint		\N	3.2.2
1337623084753-172	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.520358	214	EXECUTED	7:a369d57ca2662da122f75b8da071d19b	addForeignKeyConstraint		\N	3.2.2
1337623084753-173	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.53688	215	EXECUTED	7:ad42dcd59467e0f28e6996bb5d3c0fa4	addForeignKeyConstraint		\N	3.2.2
1337623084753-174	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.553328	216	EXECUTED	7:5f7d0419cbe31f8b8ee7df86b1937270	addForeignKeyConstraint		\N	3.2.2
1337623084753-175	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.570031	217	EXECUTED	7:3c483115556a8b38cdc15ad39c3b3492	addForeignKeyConstraint		\N	3.2.2
1337623084753-176	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.586587	218	EXECUTED	7:148ee59fc185fa10a75ccf2f2b7bbf1f	addForeignKeyConstraint		\N	3.2.2
1337623084753-177	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.603146	219	EXECUTED	7:325d811db324fa6318d992f3982290c5	addForeignKeyConstraint		\N	3.2.2
1337623084753-178	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.62	220	EXECUTED	7:a985100c3fafe73b9457178f9295a3be	addForeignKeyConstraint		\N	3.2.2
1337623084753-179	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.636183	221	EXECUTED	7:9a6ab972e31b150963fdd2356beb9c7c	addForeignKeyConstraint		\N	3.2.2
1337623084753-180	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.652749	222	EXECUTED	7:c53734d21ae9b060abeaafc155f83145	addForeignKeyConstraint		\N	3.2.2
1337623084753-181	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.677559	223	EXECUTED	7:2e163eefd39c2db61858c16001014541	addForeignKeyConstraint		\N	3.2.2
1337623084753-184	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.694135	224	EXECUTED	7:f55ae3b446a476dc9fb9411591bb2543	addForeignKeyConstraint		\N	3.2.2
1337623084753-185	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.710695	225	EXECUTED	7:4f3177adff776b02f07504d2ef55b2d8	addForeignKeyConstraint		\N	3.2.2
1337623084753-186	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.727361	226	EXECUTED	7:80107e941ca59227c531c848985c3bf9	addForeignKeyConstraint		\N	3.2.2
1337623084753-187	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.744575	227	EXECUTED	7:f7361473b2cd5d91a6a28a0154a2e095	addForeignKeyConstraint		\N	3.2.2
1337623084753-188	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.761068	228	EXECUTED	7:dcb2e6763c0d385509fb5515068667ab	addForeignKeyConstraint		\N	3.2.2
1337623084753-197	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.77752	229	EXECUTED	7:9b1b8c900ce348daae8ef8f47fdcaad0	addForeignKeyConstraint		\N	3.2.2
1337623084753-198	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.793666	230	EXECUTED	7:61387e4e43008981acc9f7b66c24c8a2	addForeignKeyConstraint		\N	3.2.2
1337623084753-199	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.809979	231	EXECUTED	7:4c6e3731514d76c12d13fae3e4fa3d23	addForeignKeyConstraint		\N	3.2.2
1337623084753-200	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.826784	232	EXECUTED	7:6859fa8993edd74e0f8a609871de66bf	addForeignKeyConstraint		\N	3.2.2
1337623084753-201	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.843347	233	EXECUTED	7:acb4a155eea2c455856a8de38cdfdd88	addForeignKeyConstraint		\N	3.2.2
1337623084753-202	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.859801	234	EXECUTED	7:3ec857f24a27a75824df0cb2f90f6344	addForeignKeyConstraint		\N	3.2.2
1337623084753-203	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.884775	235	EXECUTED	7:b2b4130291b13a57a3810adb4a47ce94	addForeignKeyConstraint		\N	3.2.2
1337623084753-204	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.901162	236	EXECUTED	7:ead685db40b963c35fc1c19741dfd38f	addForeignKeyConstraint		\N	3.2.2
1337623084753-205	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:04.984048	237	EXECUTED	7:25fa80b9806b625b5afd37bf3c5ba704	addForeignKeyConstraint		\N	3.2.2
1337623084753-206	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.000254	238	EXECUTED	7:cfc81314a958f756a9369c8a87eab006	addForeignKeyConstraint		\N	3.2.2
1337623084753-207	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.017352	239	EXECUTED	7:dec079d2acc7ffdde9f0d46e92ac1115	addForeignKeyConstraint		\N	3.2.2
1337623084753-208	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.03316	240	EXECUTED	7:5e484ec21018d0b9da7b1b9da5b7d03a	addForeignKeyConstraint		\N	3.2.2
1337623084753-209	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.049759	241	EXECUTED	7:0a30b63874b23a3d00dd0d08c74cc41c	addForeignKeyConstraint		\N	3.2.2
1337623084753-210	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.066344	242	EXECUTED	7:57e8ee891eaf66558ec183a69efbc64f	addForeignKeyConstraint		\N	3.2.2
1337623084753-211	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.082925	243	EXECUTED	7:b2b7afe0b718b46aa02588f9cd5dc90e	addForeignKeyConstraint		\N	3.2.2
1337623084753-212	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.099793	244	EXECUTED	7:be1220080dbe423f7f720d9df7179d2c	addForeignKeyConstraint		\N	3.2.2
1337623084753-213	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.11633	245	EXECUTED	7:72551c40edbab7f01d0e65f219bc5d97	addForeignKeyConstraint		\N	3.2.2
1337623084753-214	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.13251	246	EXECUTED	7:23b4bc660215da2c1b87563a29de3cbb	addForeignKeyConstraint		\N	3.2.2
1337623084753-215	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.158933	247	EXECUTED	7:cdaeac3fed333286507b082a79c96e0f	addForeignKeyConstraint		\N	3.2.2
1337623084753-216	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.192227	248	EXECUTED	7:6491850a4fe692c81fdbb217280bbe64	addForeignKeyConstraint		\N	3.2.2
1337623084753-217	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.225153	249	EXECUTED	7:f9ac90aa76552717f6b8dd874d917b41	addForeignKeyConstraint		\N	3.2.2
1337623084753-218	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.242002	250	EXECUTED	7:a42b948787df60198c9004274072a675	addForeignKeyConstraint		\N	3.2.2
1337623084753-219	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.259374	251	EXECUTED	7:49e038365abfb81b94e85c2c25d7d70d	addForeignKeyConstraint		\N	3.2.2
1337623084753-220	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.274846	252	EXECUTED	7:1500f6f47029683281bc7b2e8292f726	addForeignKeyConstraint		\N	3.2.2
1337623084753-221	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.291646	253	EXECUTED	7:129c344be312e649bf894e350d95b3e1	addForeignKeyConstraint		\N	3.2.2
1337623084753-222	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.308191	254	EXECUTED	7:42359f8afd2b6db651722cf404c60b2d	addForeignKeyConstraint		\N	3.2.2
1337623084753-223	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.324762	255	EXECUTED	7:52bb8c9f7f1ad2d08f80a47f20702e9b	addForeignKeyConstraint		\N	3.2.2
1337623084753-224	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.341466	256	EXECUTED	7:6849ea30a8540c1be986fcdfc03e17f3	addForeignKeyConstraint		\N	3.2.2
1337623084753-225	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.357902	257	EXECUTED	7:010da80e97cf08a7495a8bab95b6f65e	addForeignKeyConstraint		\N	3.2.2
1337623084753-226	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.375301	258	EXECUTED	7:42c7e285e08d764c551e2ddbcbd926e2	addForeignKeyConstraint		\N	3.2.2
1337623084753-227	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.391615	259	EXECUTED	7:b44fdcf89b27873fd93714b547314afa	addForeignKeyConstraint		\N	3.2.2
1337623084753-228	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.408105	260	EXECUTED	7:c71d08ed6e2235b7c6ae6b2594ca42ca	addForeignKeyConstraint		\N	3.2.2
1337623084753-229	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.425068	261	EXECUTED	7:75fc3797d3a4ba34b7625484fae3e0f7	addForeignKeyConstraint		\N	3.2.2
1337623084753-230	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.440668	262	EXECUTED	7:4d29bc601d3c8c90dc3641dd9f1845c4	addForeignKeyConstraint		\N	3.2.2
1337623084753-231	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.456963	263	EXECUTED	7:b2fe4aa6cee8ce8e0e6f3c5467a2c87d	addForeignKeyConstraint		\N	3.2.2
1337623084753-232	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.473311	264	EXECUTED	7:57d343b6a41f159d61cba9795c4d70ae	addForeignKeyConstraint		\N	3.2.2
1337623084753-233	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.491171	265	EXECUTED	7:17ac0584178afafd9831a8c810d9c3ee	addForeignKeyConstraint		\N	3.2.2
1337623084753-247	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.506539	266	EXECUTED	7:8de30a7a3d4fad9c4c9b534d9a32a3d9	addForeignKeyConstraint		\N	3.2.2
1337623084753-249	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.52294	267	EXECUTED	7:95a7ab19c2e772287a661a19e7c62b32	addForeignKeyConstraint		\N	3.2.2
1337623084753-250	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.539886	268	EXECUTED	7:0ef59f7c632a6c8b6f7e3e0b88534353	addForeignKeyConstraint		\N	3.2.2
1337623084753-251	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.556689	269	EXECUTED	7:e2d8293585bf55ef1030a5bbc0c41504	addForeignKeyConstraint		\N	3.2.2
1337623084753-252	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.57337	270	EXECUTED	7:3e40b2c12f93d4bb17992e6d5d01ec8d	addForeignKeyConstraint		\N	3.2.2
1337623084753-256	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.589487	271	EXECUTED	7:7744c9a47a2e8c3ff7fffd49a94010fb	addForeignKeyConstraint		\N	3.2.2
1337623084753-257	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.606243	272	EXECUTED	7:bfc0510a2ee7d38ad7ab2d75a9972d2e	addForeignKeyConstraint		\N	3.2.2
1337623084753-258	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.623331	273	EXECUTED	7:15bbd9ad1be11b4a9dcec7ed34679947	addForeignKeyConstraint		\N	3.2.2
1337623084753-259	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.638848	274	EXECUTED	7:b304182d1e2c2cdf5e7b49bd35bb80c1	addForeignKeyConstraint		\N	3.2.2
1337623084753-260	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.655448	275	EXECUTED	7:dd1ed1cac11d56dfd406defa182b6824	addForeignKeyConstraint		\N	3.2.2
1337623084753-261	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.671854	276	EXECUTED	7:968f5c629f6c1903a38ebecc8533eeef	addForeignKeyConstraint		\N	3.2.2
1337623084753-262	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.688402	277	EXECUTED	7:79156e7a592a64e23527208e5e675897	addForeignKeyConstraint		\N	3.2.2
1337623084753-263	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.705083	278	EXECUTED	7:e6db865fb6d446b2197012876fa7da21	addForeignKeyConstraint		\N	3.2.2
1337623084753-264	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.722408	279	EXECUTED	7:ea5ce4eaffe78b9c3e22df6d2b993ef4	addForeignKeyConstraint		\N	3.2.2
1337623084753-265	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.737903	280	EXECUTED	7:b31723792215e0944355c4c9e88ee4c5	addForeignKeyConstraint		\N	3.2.2
1337623084753-266	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.754662	281	EXECUTED	7:10fab1f295c37475c84fff8d5216621a	addForeignKeyConstraint		\N	3.2.2
1337623084753-267	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.770971	282	EXECUTED	7:4c19e257741ff1192e15ef611b3756d3	addForeignKeyConstraint		\N	3.2.2
1337623084753-268	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.787473	283	EXECUTED	7:f1825551f57751ddb85cdb205ece5348	addForeignKeyConstraint		\N	3.2.2
1337623084753-269	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.804066	284	EXECUTED	7:934a52ce8b78df006eb498b925c56919	addForeignKeyConstraint		\N	3.2.2
1337623084753-270	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.820648	285	EXECUTED	7:d4374eaf5120aa300a92d3c5bde3e54b	addForeignKeyConstraint		\N	3.2.2
1337623084753-272	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.837195	286	EXECUTED	7:9c64ee7a22c79f65096967374724864b	addForeignKeyConstraint		\N	3.2.2
1337623084753-273	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.85383	287	EXECUTED	7:ac2b6866e164e675a7fa39d9ebea125f	addForeignKeyConstraint		\N	3.2.2
1337623084753-274	Emiliano Conde	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.870385	288	EXECUTED	7:fdf5cb55c7696fcc46c1957aa70455c8	addForeignKeyConstraint		\N	3.2.2
1337623084753-320	Mahesh Shivarkar	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.886951	289	EXECUTED	7:692ad199923acbe9dbe6bd36ef9601e2	addForeignKeyConstraint		\N	3.2.2
1337623084753-321	Mahesh Shivarkar	descriptors/database/jbilling-schema.xml	2016-11-13 21:00:05.903518	290	EXECUTED	7:dce9f5277aff5d62f2665f00f3bf2159	addForeignKeyConstraint		\N	3.2.2
min-balance-to-ignore-ageing	Panche Isajeski	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.340211	291	EXECUTED	7:2c3823a513867c4974079fccc4787df3	insert (x3)	March 27, 2012 Redmine #2486 New Preference - Min Balance to ignore Ageing/Overdue Notifications	\N	3.2.2
eliminate-main-order_alter-columns	Emiliano Conde	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.36892	292	EXECUTED	7:00b76184f13f90864b269dade8f8b524	addColumn, update (x2), addForeignKeyConstraint, dropForeignKeyConstraint, dropColumn (x2)	April 23, 2012 - Redmine #922 - Eliminate Main Order	\N	3.2.2
eliminate-main-order_update-data-psql	Emiliano Conde	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.465164	293	EXECUTED	7:bd17e924a4b0dbf9d818efef7914cb75	update (x2), dropColumn (x2)	April 23, 2012 - Redmine #922 - Eliminate Main Order	\N	3.2.2
fix-min_params_SimpleTaxCompositionTask	Emiliano Conde	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.481274	294	EXECUTED	7:fe9e061efc641247abdd965f5ab02e5b	update	April 24, 2012 - Fix to SimpleTaxCompositionTask	\N	3.2.2
clear-empty-meta_fields	Emiliano Conde	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.50475	295	EXECUTED	7:c03db8bd29d2054324c086e03f30c4d3	delete (x2)	May 22, 2012 - Remove empty string metafields	\N	3.2.2
notification-message	Panche Isajeski	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.534002	296	EXECUTED	7:8b28a3fb0056977c21990000adeefab4	addColumn (x3), insert (x2)	May 28, 2012 - Adding notification messages	\N	3.2.2
attach-overdue-invoices-to-notifications	Panche Isajeski	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.555764	297	EXECUTED	7:e7e15513c4239eb838787f550dcd5d06	insert (x3)	May 31, 2012 Redmine #2718 Attach Invoices to all Overdue Notifications	\N	3.2.2
20120608-#2725-notification-category	Vikas Bodani	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.572945	298	EXECUTED	7:90397ac5f5c6af71ceb30284faa51ede	insert	June 15, Redmine #2725 - Custom Notification Category	\N	3.2.2
custom-notification-feature	Shweta Gupta	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.604458	299	EXECUTED	7:696537b57591f8cbf39624fefbb60676	addColumn (x4), update (x4)	June 20, 2012 Redmine #2725 Custom Notification Feature	\N	3.2.2
20120606-2718-overdue-invoice-penalty-order-task	Vikas Bodani	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.631016	300	EXECUTED	7:85ff1cd4b3f3b3e21b2a84d55ba4383a	insert (x3), update	Overdue Invoice penalties plug-in - new feature	\N	3.2.2
remove-rules-generator-task	Brian Cowdery	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.646199	301	EXECUTED	7:24c6b80505bf3a623c3189f300e5805f	delete (x3)	July 8, 2012 Redmine # 3023 Remove rules generator API	\N	3.2.2
add-event-based-custom-notification-task	Panche Isajeski	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.663143	302	EXECUTED	7:c912f82eb7120badbcbb45504d2cadc4	insert (x3)	Jul 12, 2012 - #2725 - Custom notifications	\N	3.2.2
3990 - Made order_id persistent to invoiceLineDTO	Vikas Bodani	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.680514	303	EXECUTED	7:37fb18bd6a347d0468c08992bf68a934	addColumn, addForeignKeyConstraint	Requirement 3990 - Added order_id to the Invoice_Line table.	\N	3.2.2
2006 - Force Unique Emails Preference	Vladimir Carevski	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.696386	304	EXECUTED	7:f4c6c02953c9021414768dad5dfc73c7	insert (x3)	Bugs #2006 - Option to force unique emails in the company	\N	3.2.2
4474 - Entity to be deletable.	Amol Gadre	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.799931	305	EXECUTED	7:9bfe1c0e1bcb165d49966db06c6543e3	addColumn	Requirement #4474 - Added deleted column in entity to allow for soft deletion.	\N	3.2.2
change-category-for-penalty-task	Panche Isajeski	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.829414	306	EXECUTED	7:34f5913c5a3f26d196cb99777fe7e376	update		\N	3.2.2
add-new-suretax-engine-base	Amol Gadre	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:06.964182	307	EXECUTED	7:b537cd361acb0cf41e6f617f4e4525ab	insert, createTable, insert (x4)	Jun 24, 2013 - Add Suretax Processing	\N	3.2.2
20121120 #3304 Jbilling Core Changes for Discounts	Amol Gadre	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:07.219747	308	EXECUTED	7:df9c63a9e4d4462edc9bff8e759d0d74	createTable (x2), addPrimaryKey, addForeignKeyConstraint (x2), createTable, addForeignKeyConstraint (x4), insert (x5)	20121120 #3304 Jbilling Core Changes for Discounts: Added new tables related to discounts functionality.	\N	3.2.2
20121213 #3452 Last Updated date time added on Discount	Amol Gadre	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:07.235657	309	EXECUTED	7:8b8068ba80ae36348ad0be3e89da803b	addColumn	20121213 #3452 Last Updated date time added on Discount.	\N	3.2.2
20121031 #3530 Merchant Account Relationships	Amol Gadre	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:07.261195	310	EXECUTED	7:438e0417fcb7e10e5bfe5972dbfcff60	addColumn, addForeignKeyConstraint	#3530 - Added new column to purchase order called primary order id to link the orders while creating a plan order.	\N	3.2.2
4933 - Invoice Date and Invoice Due Date are Incorrect	Maruthi	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:07.275516	311	EXECUTED	7:3681aa0a29b8bdec4aa7ef5ca86cb256	update (x2)		\N	3.2.2
fix-column-name-length	Juan Vidal	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:07.326245	312	EXECUTED	7:66ba15060609eee70a014cc0849cdd52	dropForeignKeyConstraint, renameColumn, addForeignKeyConstraint	Fix to rename the column name to less than 30 characters to avoid errors in Oracle.	\N	3.2.2
Requirement-5461	Rahul Asthana	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:07.341603	313	EXECUTED	7:d0deb14443f14c174b966b7f11391ae6	update	Fix Unable to create new enumerations.	\N	3.2.2
#6076-add-notification-for-refunds	Juan Vidal	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:07.358768	314	EXECUTED	7:46495a67401a323908715262572724ba	insert (x2)		\N	3.2.2
#6250-Tables-without-primary-keys	maruthi	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:08.285773	315	EXECUTED	7:8f1d3152721f2838206cde44ff8707d6	sql (x3), delete, insert, addPrimaryKey, createSequence, addColumn, createSequence, addColumn, createSequence, addColumn, addPrimaryKey (x13)		\N	3.2.2
#6183-credit-card-transaction-report-renamed-cc	Juan Vidal	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:08.31624	316	EXECUTED	7:fa8164800bdcd87f01715f68281a6aad	update		\N	3.2.2
#6250-Tables-without-primary-keys - correction - 3	Vikas Bodani	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:08.332428	317	EXECUTED	7:c908088e56120afca458636804c41bc1	update		\N	3.2.2
#7339 - Added to fix the null value in category Type dropdown	Vishwajeet Borade	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:08.348382	318	EXECUTED	7:a4f7eff5e35244954275ae4f40bc23ee	insert	Added to fix the null value in category Type dropdown	\N	3.2.2
#8469-billing-process-invoice-date-simplified	Ashok Kale	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:08.45025	319	EXECUTED	7:f31c45d9cd97b60b26ee578660caf3d3	addColumn (x2), addForeignKeyConstraint	Requirement Add Customer level Next Invoice date	\N	3.2.2
#8469-Log-next-invoice-date-update.	Ashok Kale	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:08.465307	320	EXECUTED	7:96b6f6b6610bbf7d3125ccd46d4b7b80	insert		\N	3.2.2
#8469-billing-process-semi-monthly-period-unit	Amol Gadre	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:08.481139	321	EXECUTED	7:51e84dff9db24846b0d6d27f9cc8ca14	insert (x2)	Requirement Add new semi-monthly period for billing process	\N	3.2.2
#8469-Add-New-flag-last-day-of-invoice	Ashok Kale	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:08.590081	322	EXECUTED	7:6c6d5a3e7496441006daff7a3ab18534	addColumn, insert		\N	3.2.2
#8469-Add-prorating-options	Ashok Kale	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:08.926289	323	EXECUTED	7:1958a9aa62c52aad9c7338da0836efd1	addColumn (x2)		\N	3.2.2
#8469-remove-pro-rate-tasks	Ashok Kale	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:08.952593	324	EXECUTED	7:b5de1ee40993b77c87eb2ef6adbb55f4	delete (x4)	June 10, 2014 Redmine # 8469 Remove ProRateOrderPeriodTask Plugin\nJune 10, 2014 Redmine # 8469 Remove DailyProRateCompositionTask Plugin	\N	3.2.2
#10005-Last Day of Month not Behaving as Expected	Manish Bansod	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:08.968947	325	EXECUTED	7:16383077db84e9d6f56752447c661cb9	delete	# 10005 Delete Use Prorating preference	\N	3.2.2
20141211 - correcting next_ids	Rohit Gupta	descriptors/database/jbilling-upgrade-3.2.xml	2016-11-13 21:00:08.985221	326	EXECUTED	7:75d374236ddd2a1db3a6dc078729e93b	update		\N	3.2.2
#3173 - Create a New Payment Method 'Credit'	Oscar Bidabehere	descriptors/database/jbilling-upgrade-3.3.xml	2016-11-13 21:00:09.487081	327	EXECUTED	7:d4c0e5904753ca7ba863f5791c6fdd3b	insert (x5), update, sql, update		\N	3.2.2
#4781 - Dynamic tab configuration	Gerhard Maree	descriptors/database/jbilling-upgrade-3.3.xml	2016-11-13 21:00:09.681739	328	EXECUTED	7:e18000d07a6fa96fefa9e6ed6499c28f	createTable (x2), addForeignKeyConstraint, createTable, addForeignKeyConstraint (x2), insert (x10)		\N	3.2.2
#4781 - Dynamic tab configuration - Discounts menu item	Gerhard Maree	descriptors/database/jbilling-upgrade-3.3.xml	2016-11-13 21:00:09.712983	329	EXECUTED	7:491a8a91b812e15cdc356ec9e6d6f794	addColumn, update (x2), insert		\N	3.2.2
#1905 - Reset password	Oscar Bidabehere	descriptors/database/jbilling-upgrade-3.3.xml	2016-11-13 21:00:09.852629	330	EXECUTED	7:97686600f147d2bf90e3cf499aaefa00	createTable, sql, update, sql (x3), update, sql (x3), update	Default configuration\nid = maxMessageId + count\nmessage_id = maxMessageId - count\nmessage_id = maxMessageId - count\nmessage_id = maxMessageId - count\nmessage_section_id = (maxSectionId + 1 - (3 * entityCant)) + count\nmessage_section_id = (maxSecti...	\N	3.2.2
20121231-#2488,BalanceBelowThresholdNotificationTask-1	Shweta Gupta	descriptors/database/jbilling-upgrade-3.3.xml	2016-11-13 21:00:09.87688	331	EXECUTED	7:6fadc677d51171b6542fb9f68b67ce3f	insert (x7), update (x2)		\N	3.2.2
#3374-Ageing improvements	Panche Isajeski	descriptors/database/jbilling-upgrade-3.3.xml	2016-11-13 21:00:10.477669	332	EXECUTED	7:fd918e5b1d85c2d803a60d48659e0b1f	createTable, insert, addColumn, sql, update, addForeignKeyConstraint, sql (x7), delete, update (x2), delete, addUniqueConstraint, insert (x3), update	#3374-Separate auto payment retry from the billing process\nMigration scripts\nNew UserAgeingNotificationTask for mapping between notifications and user statuses	\N	3.2.2
20130305 - #3307	Shweta Gupta 	descriptors/database/jbilling-upgrade-3.3.xml	2016-11-13 21:00:10.504408	333	EXECUTED	7:ee1b60bd538330b881d7754ca296756a	insert (x3)	Add New Preference - Unique Product Code	\N	3.2.2
20121207-#4042-add-parent-item-type-column	Vladimir Carevski	descriptors/database/jbilling-upgrade-3.3.xml	2016-11-13 21:00:10.521719	334	EXECUTED	7:f8ef413e9a2c9bb407408497d5abbb86	addColumn, addForeignKeyConstraint	Dec 07, 2012 - #4042, Adds column for parent item type id	\N	3.2.2
#7623, Configure password rules	Rohit	descriptors/database/jbilling-upgrade-3.3.xml	2016-11-13 21:00:10.543419	335	EXECUTED	7:7530bbe34c559ca4d74ef84b11b6217c	addColumn		\N	3.2.2
#8043, add column in item table	Rohit	descriptors/database/jbilling-upgrade-3.3.xml	2016-11-13 21:00:10.564143	336	EXECUTED	7:408ea8eb15a4583cf2fa2e0d2f881992	addColumn		\N	3.2.2
20141112-correcting sequences	Manisha Gupta	descriptors/database/jbilling-upgrade-3.3.xml	2016-11-13 21:00:10.578735	337	EXECUTED	7:633a3f89bd3692aeb80f99645cc3e5c8	update		\N	3.2.2
#4938 - Asset Management - Entites	Gerhard Maree	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:11.521003	338	EXECUTED	7:d2fdd52f6735f83b8e5f6b04460b54a5	createTable, addForeignKeyConstraint, insert (x2), addColumn, createTable, addForeignKeyConstraint (x2), addColumn (x2), createTable, addForeignKeyConstraint (x4), insert (x2), createTable, addForeignKeyConstraint (x2), createTable, addForeignKeyC...	Asset Status related changes\nItem related changes\nItemType related changes\nAsset related changes\nAsset Transition related changes	\N	3.2.2
#4938 - Asset Management - Pluggable Tasks	Gerhard Maree	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:11.58994	339	EXECUTED	7:a30c26ed09010e0ef0bfd85459179416	insert (x3), sql, insert (x3), sql, insert (x3), update, sql, update	Register 3 new tasks:\n            FileCleanupTask - This task will delete files older than a certain time. The task is only\n                scheduled for the first entity since it will look at the same folder for all entities.\n            AssetUpd...	\N	3.2.2
20130719 #5729: - Asset Groups - Entites	Gerhard Maree	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:11.717573	340	EXECUTED	7:0794a98449f5c2e12f9bed3b52bc3b1a	sql, update (x4), delete, update, addColumn (x2), insert (x2)	Asset Groups related changes	\N	3.2.2
spring-batch-tables	Emiliano Conde	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:12.186809	341	EXECUTED	7:171c3c92d345411b881249972ed15ce1	createTable (x6)	These are the tables and sequences needed by Spring Batch to work.\n            Note that this will not work on MySQL, since it does not have sequences\n            Yet S Batch does support MySQL so there has to be some alternative	\N	3.2.2
spring-batch-key-gen-postgres	Gerhard Maree	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:12.224802	342	EXECUTED	7:1697a7d7e2db05f07efb4b7b86347509	createSequence (x3)	These are the tables and sequences needed by Spring Batch to work on postgres.	\N	3.2.2
Customer Account Type	Rahul Asthana	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:12.325464	343	EXECUTED	7:9f5503ac5a2c53c02ec46203641f4838	createTable, addForeignKeyConstraint (x5)		\N	3.2.2
add-account-type-in-jbilling_table	Rahul Asthana	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:12.341087	344	EXECUTED	7:cf0e47a00053bd4f99942c4ce646b197	insert		\N	3.2.2
5015-remove-auto-payment	Gurdev Parmar	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:12.38218	345	EXECUTED	7:a8840e138fbc85667758c15a348a4f1d	dropColumn		\N	3.2.2
20130514-#4987-account-type-management	Vladimir Carevski	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:12.412562	346	EXECUTED	7:44dda31d011da48e31cf24dd75f36b59	insert, addColumn, addForeignKeyConstraint		\N	3.2.2
20130516-#4988-account-type-pricing	Panche Isajeski	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:12.4404	347	EXECUTED	7:a3561ad5969bb383639dbbfd40165abd	createTable (x2)		\N	3.2.2
20130516-#4988-account-type-pricing-item-std-avail	Gerhard Maree	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:12.592583	348	EXECUTED	7:118755081f859e1201bd197f44fbd0ba	addColumn	The follow 2 change sets are required until https://liquibase.jira.com/browse/CORE-1260 is fixed.\n            The default value for mysql should be 0 or 1 of type tinyint	\N	3.2.2
20130429-#4920	Oleg Baskakov	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:12.725275	349	EXECUTED	7:d8cd8ca4d3f3f1cc4f3e25c049ee2a71	createTable (x2), addColumn, insert (x3)	Requirement #4920 - Create MetaField Groups.	\N	3.2.2
20130429-#4920-bool-fix	Gerhard Maree	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:12.862137	350	EXECUTED	7:8b80ccaff04a22b6df35c6b875c8f5f3	addColumn	The follow 2 change sets are required until https://liquibase.jira.com/browse/CORE-1260 is fixed.\n            The default value for mysql should be 0 or 1 of type tinyint	\N	3.2.2
20130506-#4921	Oleg Baskakov	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:12.885766	351	EXECUTED	7:a65ad49096481e8b5f8e32abf20ccc85	createTable	Requirement #4921 - MetaField validation rules.	\N	3.2.2
20130513-#4922	Oleg Baskakov	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:12.906456	352	EXECUTED	7:1970e21215fc78e9db1c896c99bb0c35	addColumn, addForeignKeyConstraint	Requirements #4922 - Create Account Information Types (AIT)	\N	3.2.2
#5388-Java based Metafield validation	Panche Isajeski	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.060213	353	EXECUTED	7:1387a5fbc16e5986b74c3fe3c5c49ad4	createTable, dropColumn, addColumn, addForeignKeyConstraint, createTable, insert (x2)	Metafields - Custom Java validators	\N	3.2.2
#5137-remove-contact-type-constraints-on-contact-map	Vladimir Carevski	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.084342	354	EXECUTED	7:881e8c84288d3af8cffdc4d0667417ce	dropNotNullConstraint, dropForeignKeyConstraint, dropIndex, addForeignKeyConstraint		\N	3.2.2
20130531-#5237-product-dependencies	Shweta Gupta	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.342087	355	EXECUTED	7:ec8bd52646e88556a9e0b14df38d0b04	createTable, addPrimaryKey, addForeignKeyConstraint (x2), createTable, addPrimaryKey, addForeignKeyConstraint (x2), createTable, addPrimaryKey, addForeignKeyConstraint (x2), createTable, addPrimaryKey, addForeignKeyConstraint (x2)		\N	3.2.2
#5293_product_inherited_order_meta_fields	Alexander Aksenov	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.365966	356	EXECUTED	7:218b3ffdf03f97e2e369076b4537a734	createTable, addForeignKeyConstraint (x2)	Item related changes	\N	3.2.2
1337623084753-114	Maruthi	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.440151	357	EXECUTED	7:91bbe9c305dc6d45e0ebb5712cbf6d03	createTable		\N	3.2.2
#5338 Route-based Rating	Rahul Asthana	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.50657	358	EXECUTED	7:74d50fa474a8287b861d9889a09e815b	createTable		\N	3.2.2
#5557 Matching Field	Rahul Asthana	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.624056	359	EXECUTED	7:b4999f87529380b9c16a22d45a9dc479	createTable, addForeignKeyConstraint, insert		\N	3.2.2
#5373 - Development: Order Hierarchies	Alexander Aksenov	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.65821	360	EXECUTED	7:7bcddb9931fc77dbfc1468c28ed2166b	addColumn, addForeignKeyConstraint, addColumn, addForeignKeyConstraint		\N	3.2.2
#5712 - MF1J - Java based Metafield validation	Shweta Gupta	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.688153	361	EXECUTED	7:5858b0d04db53a21ea68c7f472adbbef	addForeignKeyConstraint		\N	3.2.2
#5294_order_cancellation_fields	Bilal Nasir	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.710934	362	EXECUTED	7:5e6b43749bcbda647a86bd6891fd2839	addColumn	Adding fields in purchase_order table for order cancellation fees	\N	3.2.2
#5294_order_cancellation_fields_table_entries	Bilal Nasir	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.737936	363	EXECUTED	7:97b97b614724bbde22367f3d19a3ce34	insert (x3), delete (x6), update		\N	3.2.2
requirement # 5292 - 01	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.75388	364	EXECUTED	7:35ac07f331f3c11d41982ef04953ba2d	createTable		\N	3.2.2
requirement # 5292 - 02	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.770504	365	EXECUTED	7:f9a9541a223b7905f5ccf71cafa5c8af	addForeignKeyConstraint (x2)		\N	3.2.2
requirement # 5292 - 03	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.891751	366	EXECUTED	7:2815b73b41101a9567d0c49dde4ad0db	addColumn		\N	3.2.2
requirement # 5292 - 04	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.919831	367	EXECUTED	7:a01619e40c28ad9505f080f276c44372	addForeignKeyConstraint		\N	3.2.2
requirement # 5292 - 05	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.937826	368	EXECUTED	7:76b7bf5d31d076ea4ae38bb45110c3d1	createTable		\N	3.2.2
requirement # 5292 - 06	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.953288	369	EXECUTED	7:ae82d4daa14928c7b38f34d96d4ef4c9	createTable		\N	3.2.2
requirement # 5292 - 07	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.969044	370	EXECUTED	7:b2eef522b8addd13d271c89c76fa2fbf	addForeignKeyConstraint		\N	3.2.2
requirement # 5292 - 08	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:13.985475	371	EXECUTED	7:354ce8459251270332180a883ec30e4c	addForeignKeyConstraint		\N	3.2.2
requirement # 5292 - 09	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:14.001758	372	EXECUTED	7:299292a3b10a69946707299c7aa4529e	addForeignKeyConstraint		\N	3.2.2
requirement # 5292 - 10	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:14.018163	373	EXECUTED	7:edce3c6ab8382969e9a86616211c3b10	addForeignKeyConstraint		\N	3.2.2
requirement # 5292 - 11	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:14.25094	374	EXECUTED	7:266de35f318964ea6e5545b627d56361	addColumn (x3)		\N	3.2.2
requirement # 5292 - 15	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:14.316834	375	EXECUTED	7:47e7d73bd6ae93e363b5fdbeae40884f	insert (x2)		\N	3.2.2
requirement 5546 - 20130716	Vikas Bodani	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:14.332945	376	EXECUTED	7:04f4f30ff077cf6232bf16ff28d07515	insert (x2)		\N	3.2.2
requirement # 5292 - remove-asset-entity-not-null-constraint	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:14.349149	377	EXECUTED	7:503c9aa34417ed7ea608a1b03a56c6d6	dropNotNullConstraint		\N	3.2.2
#5487-script-meta-field	Vladimir Carevski	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:14.367655	378	EXECUTED	7:bdab9ba9fe71dcf375b29e12b29cf63a	addColumn		\N	3.2.2
#6168 - item_type_nullable_entity	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:14.382247	379	EXECUTED	7:db4aaea8fc94c588bbcbf5c8669f6b18	dropNotNullConstraint		\N	3.2.2
#6168 - unique constraint on item_entity_map	Vikas Bodani	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:14.465335	380	EXECUTED	7:4dafd75c51626cba097550e5a361bf64	addUniqueConstraint		\N	3.2.2
#5711 - ait-timeline	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:14.61542	381	EXECUTED	7:417f4c5985c69d9d73152ea0c3a4a2f5	createTable, addPrimaryKey, addUniqueConstraint, addForeignKeyConstraint (x3)		\N	3.2.2
20130912-#5815 Minimum Quantities for Dependencies	Gerhard Maree	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:14.70588	382	EXECUTED	7:d49db9f84717e284b7619fab51e4a853	createTable, addForeignKeyConstraint (x3), insert (x2)	Specify minimum and maximum quantities for product dependencies	\N	3.2.2
20130912-#5815 Migration	Gerhard Maree	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:14.738881	383	EXECUTED	7:04be598da069bc74137fabd238e04d70	sql, dropTable (x4), update		\N	3.2.2
20130830-#5611	Maeis Gharibjanian	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:14.757348	384	EXECUTED	7:39859cc89c1f1b4fde2672682aa2a5e8	addColumn	Adds columns to customer for credit notification limit1 and limit2	\N	3.2.2
springbatch - #5336 - 1	Khobab	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:14.846554	385	EXECUTED	7:2f860f0f6789fb382e59594e7b5b2a3f	createTable		\N	3.2.2
springbatch - #5336 - 3	Khobab	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:14.920056	386	EXECUTED	7:eec0f5a2272c3b8dfa082371c5f89dd7	createTable		\N	3.2.2
#5447 - Development: Order Changes as Entities	Alexander Aksenov	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:15.111704	387	EXECUTED	7:f112cf5da994ab8cd38cccf951609b08	addColumn, addForeignKeyConstraint, insert (x7), update, createTable, addForeignKeyConstraint (x8), createTable, addForeignKeyConstraint (x2), insert (x2), update (x2), insert, update		\N	3.2.2
#5449 - Integrate Product Meta Fields into Order Changes	Gerhard Maree	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:15.14377	388	EXECUTED	7:8e8ab3bc5294b39365aee082e96c19f7	createTable, addForeignKeyConstraint (x2), createTable, addForeignKeyConstraint (x2)	Order Change Meta Fields\nOrder Line Meta Fields	\N	3.2.2
#6719 - User Codes - Entities	Gerhard Maree	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:15.318119	389	EXECUTED	7:ecc7ba52218940cc22955493a97830fa	createTable, insert, createTable, insert, sql, update		\N	3.2.2
#6593-order-line-tiers	Bilal Nasir	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:15.408002	390	EXECUTED	7:c5ae291e303f1323fae1aef75f5825c1	createTable, addForeignKeyConstraint, insert (x4)		\N	3.2.2
#6652-olt-add-column	Amol Gadre	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:15.424846	391	EXECUTED	7:b979830baca77dd6e95a0e345f12f5d9	addColumn		\N	3.2.2
#6652-order-add-column	Amol Gadre	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:15.441436	392	EXECUTED	7:2c72e0d8e34d747f3815c3a22471c92f	addColumn		\N	3.2.2
account-payment-information - #6315	Khobab	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:15.817307	393	EXECUTED	7:83a9e0c94b5a665d2dfa68895f491e2b	createTable (x7), addForeignKeyConstraint (x12), insert (x6), dropNotNullConstraint, createTable, insert, addForeignKeyConstraint (x4)		\N	3.2.2
#7308-usage-pool-consumption-notification	Amol Gadre	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:15.847708	394	EXECUTED	7:9c648bdc6740de93779d9533edcf3bfe	insert (x2), update (x3)		\N	3.2.2
#7308-usage-pool-consumption-notification-test	Amol Gadre	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:15.872812	395	EXECUTED	7:0eb341e7dab62b491edb3fe9932e044e	sql, insert (x5)		\N	3.2.2
#7659-Free-Usage-Pool-Consumption-enhancements	Marco Manzi	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:15.997671	396	EXECUTED	7:883b751603c3b1299174c1a6df32e43c	createTable, insert (x102)		\N	3.2.2
#7308-fup-consumption-notification-fix1	Vishwajeet Borade	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.01523	397	EXECUTED	7:1720b88970f225f807be644b2d125c28	sql		\N	3.2.2
#7308-fup-consumption-notification-fix2	Vishwajeet Borade	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.022161	398	EXECUTED	7:4020163297c93573760e0645041ddcdb	sql		\N	3.2.2
#7308-fup-consumption-notification-fix3	Vishwajeet Borade	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.131838	399	EXECUTED	7:d0e293b6414a84ce567927961e73ad1e	sql		\N	3.2.2
#7308-fup-consumption-notification-fix4	Vishwajeet Borade	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.147953	400	EXECUTED	7:5a7cc6544394c7727cf3d163f8a2fd98	sql		\N	3.2.2
#7308-fup-consumption-notification-fix5	Vishwajeet Borade	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.163767	401	EXECUTED	7:4c018f3bea4ef8a47887d4c6d2e075fa	sql		\N	3.2.2
#7308-fup-consumption-notification-fix6	Vishwajeet Borade	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.171908	402	EXECUTED	7:4b81145d0c0e67bd459e28816c484296	sql		\N	3.2.2
#8048-usercodes-unique-per-company	Nelson Secchi	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.186205	403	EXECUTED	7:28980cb681fbdc0e448c86dc2f04e98d	dropUniqueConstraint		\N	3.2.2
7043 - Agents and Commissions	Oscar Bidabehere	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.302684	404	EXECUTED	7:63bac3333365edfa44eb80427e11b93d	addColumn (x4), createTable (x2), addColumn, createTable (x4), insert (x5), createTable, insert (x3), sql, insert (x3), sql, dropColumn (x4), dropForeignKeyConstraint, dropColumn, dropForeignKeyConstraint, dropColumn (x4), dropForeignKeyConstraint...	Add partnerType, partner.parentId, standard and master percentages\nAdd commission exception\nAdd referral commission\nAdd agent commission type property\nCreate partner commission\nCreate commission run\nCreate invoice commission\nCreate payment commiss...	\N	3.2.2
Source Readers: pluggable tasks	Marco Manzi	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.326928	405	EXECUTED	7:1e1d51ff104dbbe2f25cff972dcdf3c2	insert (x3)		\N	3.2.2
Source Readers: file exchange plugin	Marco Manzi	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.343578	406	EXECUTED	7:5d0b7abcbbf2287d47133aaad9b51c8a	delete (x3), insert (x5)		\N	3.2.2
#7514 - Plans Enhancement	Khobab Chaudhary	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.524695	407	EXECUTED	7:3eebe2b901823f735e1af9c338fb9ab6	addColumn (x4)		\N	3.2.2
#6266-file-exchange-trigger	Vladimir Carevski	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.558511	408	EXECUTED	7:95ecc9a183e2e43e0d74e6eb32f42c8a	insert (x3), update		\N	3.2.2
#7223 - Preference for enabling JQGrid on the site	Nelson Secchi	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.57494	409	EXECUTED	7:0795907fcd15d8777f2df05286dbf047	insert (x3)	Should use JQGrid for tables	\N	3.2.2
#8418 - adding currency to commissions	Morales Fernando G.	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.593939	410	EXECUTED	7:599beaeb7aa83fa707ea18b19b0b7258	addColumn, addForeignKeyConstraint	Add currency to commissions	\N	3.2.2
#8009-Validation message for lnvalid 'expiry date' field	Sagar Dond	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.604628	411	EXECUTED	7:5f623e0c502a92b6cccc88f1f1215d76	update		\N	3.2.2
#6652 - Delete reference of order line tier	Ashok Kale	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.624962	412	EXECUTED	7:bf1239f8e9385db08b1da96c0efc5e12	dropTable, delete (x2)		\N	3.2.2
agent_default_preference	Morales Fernando G.	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.641244	413	EXECUTED	7:3b9f1b6dedb65bdac5086bd35e4ac733	insert (x3)	Add Agent commission type preference	\N	3.2.2
removed-order-line-tier	Mahesh Shivarkar	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.657073	414	EXECUTED	7:edd844449601a623c204668044c6654f	delete (x3)	Removed unused preference for order line tiers i.e. 'Create Invoice Lines based on Order Line Tiers'	\N	3.2.2
20141104-#10343 - entity_id should not be null	Aman Goel	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.673462	415	EXECUTED	7:3668a67b8bb39013dae8514af6fd12dd	addNotNullConstraint		\N	3.2.2
#9958 - different activeSince and activeUntil dates in same PO	Igor Poteryaev	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.76316	416	EXECUTED	7:32f57a2b2dddc066ccbbbb147f326e81	addColumn (x2), createIndex	Add db objects for order line tiers support	\N	3.2.2
#10777 - CreditLimitationNotificationTask is missing	Juan Vidal	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.798026	417	EXECUTED	7:9afafd7f13099e9812dbd5123a432019	insert (x7), update		\N	3.2.2
#12343-Update customer data	Fernando G. Morales	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:16.808671	418	EXECUTED	7:67d910c5822eb841887706244f0b23f9	customChange	Set next_invoice_date value	\N	3.2.2
#5137-migrates-data-for-customer-account	Vladimir Carevski	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:17.1271	419	EXECUTED	7:4a4cc11ccdedde7c7844d011105c968b	customChange, dropForeignKeyConstraint, dropColumn, dropTable, createIndex		\N	3.2.2
#company-hierarchy-feature-migrate-existing-items-plan-items	Vikas Bodani	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:17.13871	420	EXECUTED	7:0dce60fa9cede4425400370b27581df8	customChange		\N	3.2.2
1234567891234	Vivek Sadh	descriptors/database/jbilling-upgrade-3.4.xml	2016-11-13 21:00:17.152398	421	EXECUTED	7:c5b967beacf4fc8f89cd8b48329d5403	addForeignKeyConstraint		\N	3.2.2
add diameter entities	Emir Calabuch	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:17.349607	422	EXECUTED	7:7474da8657492a7d568d0f2d67df1ed7	createTable (x2)	Tables used for managing charge sessions and reservations	\N	3.2.2
add diameter constraints	Emir Calabuch	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:17.482922	423	EXECUTED	7:7eee27f2b9788785fde64962a409734c	addPrimaryKey (x2), addForeignKeyConstraint (x2)		\N	3.2.2
#4184 - Implement 'Start Session' API call	Sergio Liendo	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:17.508175	424	EXECUTED	7:c5c3d38f8ce0d5cae43f534a7780aad4	insert (x9)	Preference diameter destination realm\nPreference diameter quota threshold\nPreference diameter session grace period seconds	\N	3.2.2
add data column to reserved_amounts table	Oscar Bidabehere	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:17.582412	425	EXECUTED	7:ac3c9368641cd88fcfafeab62b275e20	addColumn		\N	3.2.2
add quantity column to reserved amounts table	Emir Calabuch	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:17.599601	426	EXECUTED	7:716885f9c1ae83d8e2e9582867f88c2d	addColumn		\N	3.2.2
add quantity multiplier	Emir Calabuch	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:17.614918	427	EXECUTED	7:2b0a54d788cfc1457414a4e8174b3f12	insert (x3)	Preference diameter unit multiplier/divisor	\N	3.2.2
#4430 - Call details in order line item	Oscar Bidabehere	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:17.632206	428	EXECUTED	7:2ded88547e96ce18fd37bc03d6ad5359	addColumn		\N	3.2.2
Requirements #4501 - Per-customer automatic top-up parameters	Oscar Bidabehere	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:17.650869	429	EXECUTED	7:44a56451dbd82dc5a22e7cf955c37e02	addColumn		\N	3.2.2
add carried_units column to charge_sessions table	Oscar bidabehere	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:17.664921	430	EXECUTED	7:065b32fae40e53e3bb00586ff1d93359	addColumn		\N	3.2.2
20130510-#4989-customer-notes	Rahul Asthana	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:17.805889	431	EXECUTED	7:542267d600932a00e7833f1129895744	createTable, addForeignKeyConstraint (x3), dropColumn, insert		\N	3.2.2
20130520-#4962-customer-notes	Rahul Asthana	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:17.821546	432	EXECUTED	7:f7cd7541be674333464e0fb502bf55fe	dropColumn		\N	3.2.2
20130820-add-rating-unit	Panche Isajeski	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:17.897113	433	EXECUTED	7:f825b9ce1cfb3164a9aeb9ae51e788e5	createTable, addForeignKeyConstraint		\N	3.2.2
20130820-default-rating-unit-rate-card	Panche Isajeski	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:17.92109	434	EXECUTED	7:f6e1a99e5e987c5b000f24664961e211	sql, insert, update, insert		\N	3.2.2
hierarchical_routing	Vladimir Carevski	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:18.022008	435	EXECUTED	7:54470187053a8dd94f3b546408606bd7	addColumn		\N	3.2.2
20131024 hierarchical_routing - default_route	Gerhard Maree	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:18.096713	436	EXECUTED	7:73a67ef5edeefe72c11797d250df3f65	addColumn		\N	3.2.2
20140220 #7520 - Order Changes Type	Alexander Aksenov	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:18.205806	437	EXECUTED	7:8d04933074b145c09fe06565971e099d	createTable, addForeignKeyConstraint, insert (x2), createTable, addForeignKeyConstraint (x2), createTable, addForeignKeyConstraint (x2), insert, addColumn (x2), update, addNotNullConstraint, addForeignKeyConstraint (x2)		\N	3.2.2
20140227 #7520 Order Changes Type plugin for orderStatus change	Alexander Aksenov	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:18.235589	438	EXECUTED	7:fc39c0bba8b433d4e4516d9325f43546	insert (x3), update, sql, update		\N	3.2.2
#7870:fix-product-id-in-route-tables	Marco Manzi	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:18.409926	439	EXECUTED	7:7c21f0dc9ff599fa785adc9cdcadd3c3	sql		\N	3.2.2
#7899 - Subscription Products	Khobab Chaudhary	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:18.425546	440	EXECUTED	7:5d7de50b28e1f805ddcb8148bd2d4953	insert (x2)		\N	3.2.2
#8330:reassign_the_same_asset_for_terminated_order	Marco Manzi	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:18.463994	441	EXECUTED	7:a337a286ffcf639932590b433f868335	addColumn (x3), sql, dropForeignKeyConstraint, dropColumn		\N	3.2.2
#8330:start_date_not_null	Marco Manzi	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:18.491313	442	EXECUTED	7:23eba83d9ae158c19673a99d25d04d1a	addNotNullConstraint		\N	3.2.2
#8330:asset_transition_seqs	Marco Manzi	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:18.508033	443	EXECUTED	7:b75bbdc1a0aa2ba7e186eec7ca08be08	update		\N	3.2.2
20140131-7219-save-nested-search-entities	Gerhard Maree	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:18.651477	444	EXECUTED	7:b6933951ebfbed9db734706d9cb5fa88	createTable, addForeignKeyConstraint, insert, createTable, addForeignKeyConstraint, insert		\N	3.2.2
#7045-data_tables-set_it_as_route_table_or_not	Juan Vidal	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:18.792968	445	EXECUTED	7:4cb57fd508df0b3a0fc71f3a61a701a3	addColumn		\N	3.2.2
#10045:reverting_the_asset_transition_history	Marco Manzi	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:18.850814	446	EXECUTED	7:39af65a616fa06660e7b74ae0e23a5f7	addColumn, addForeignKeyConstraint, sql, dropColumn (x3)		\N	3.2.2
requirement # 9831 - global assets	Rohit Gupta	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:19.074604	447	EXECUTED	7:63938f5b0e754adaa49f994eb2b85fe6	addColumn, createTable, addForeignKeyConstraint (x2), addUniqueConstraint		\N	3.2.2
20141104-#10343 - entity_id should not be null	Aman Goel	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:19.088389	448	EXECUTED	7:3668a67b8bb39013dae8514af6fd12dd	addNotNullConstraint		\N	3.2.2
20141124-rename-partner-to-Agent	Vikas Bodani	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:19.168838	449	EXECUTED	7:4859237ad017f452ef2155abda6b4464	update, delete (x4)	Preference Types 5 through 12 should not being used anywhere. Partner is replaced with Agent.	\N	3.2.2
20141126-rename-ForeignKeyConstraint	Manisha Gupta	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:19.185339	450	EXECUTED	7:fda82f25a00179dedcf9f67836402b07	dropForeignKeyConstraint, addForeignKeyConstraint (x2)		\N	3.2.2
10632-event_base_custom_notification_fix	Marco Manzi	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:19.201714	451	EXECUTED	7:1f7f8b0812a4163b203762c36a11ea5c	update		\N	3.2.2
#9977:Partner-To-Agent-Fix-demo-data	Marco Manzi	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:19.226962	452	EXECUTED	7:60627975097a4d3abe0e1b0b175846c7	update (x9)		\N	3.2.2
#10901-Replacing Partner to Agents in Permissions page	Anand Kushwaha	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:19.242946	453	EXECUTED	7:7c98ed064910d41ca61e8868af0a2ff2	update		\N	3.2.2
Rename MENU_93	Manisha Gupta	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:19.259545	454	EXECUTED	7:bf1ad825a0ea3e5c9311a5f597535a50	update		\N	3.2.2
#11172-show-category-metafields	Prashant Gupta	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:19.284261	455	EXECUTED	7:ec5dfc56eb7419cb522aa6bb6c3b624e	createTable, addForeignKeyConstraint (x2)		\N	3.2.2
#10442 Adding All Account TypecheckboxinpaymentMethodType edit	Anand Kushwaha	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:19.387057	456	EXECUTED	7:81128e7021979b4ec0fcf54a7b4c8bd6	addColumn		\N	3.2.2
20150114 - late guided usage delete order	Vikas Bodani	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:19.410751	457	EXECUTED	7:3682052d466ffa1aa85a045098bd8347	addColumn		\N	3.2.2
11565-added-invoice-reminder-name	Prashant Gupta	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:19.425208	458	EXECUTED	7:229e007d8500b0b5648cc728c5b1ba0a	insert		\N	3.2.2
#12690-index-on_parent_id-customer-table	Prashant Gupta	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:19.511349	459	EXECUTED	7:60d91cf9ee88b4c8a882cac11c530057	createIndex		\N	3.2.2
#12691-Add field_usage column	Ravi Singhal	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:19.560865	460	EXECUTED	7:cc6b1aa2818dcbdf1c153cd86797ed63	addColumn, sql, dropTable	Drop table metafield_type_map. One meta field can have only one usage type.	\N	3.2.2
hierarchical_routing_matching_field_fix	Panche Isajeski	descriptors/database/jbilling-upgrade-4.0.xml	2016-11-13 21:00:19.766672	461	EXECUTED	7:5e97d017ce06b332f96b2c8c7394368a	update		\N	3.2.2
#6316-new-password-column-size	Maeis Gharibjanian	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:20.034891	462	EXECUTED	7:a69af898af6060ad2d0517488e188a44	modifyDataType	Increasing the size of the password column. This should be enough to store\n            most hashes generated from known hashing methods plus the generated salt.	\N	3.2.2
#6316-hashing-method-column	Khurram M Cheema	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:20.052563	463	EXECUTED	7:036f9f96c6e43aac3f5b9d35f2dfdcc0	addColumn, update, addNotNullConstraint	Adding a column to represent the encryption scheme. Here we are assuming that\n            all clients are sticking to the default password hashing method which is MD5.	\N	3.2.2
#10595-Password lockout for failed login attempts	Bilal Shah	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:20.077758	464	EXECUTED	7:f07d2c0f2498e8ef7b2587fc9a9aff76	addColumn, insert (x3), update, insert (x2)	Constant ID may need to be changed during merging of this feature to later branches to avoid overlapping with other preference IDs	\N	3.2.2
#11107 - Line Percentage	Rohit Gupta	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:20.390214	465	EXECUTED	7:6db888e7c55aeb530e55840193ee6d23	dropColumn, addColumn (x2)		\N	3.2.2
#10256:Asset Reservation	Morales Fernando G.	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:20.674857	466	EXECUTED	7:cedb8fafce6fbd6013eb22a57c560123	addColumn, createTable, createIndex, addForeignKeyConstraint (x3)	Adding reservation parameter\nAsset reservation table\nAdding indexes	\N	3.2.2
#11243-AIT-Inhancement	Rohit Gupta	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:20.697243	467	EXECUTED	7:14eae727b861c4856f58f3c2d09763a0	addColumn		\N	3.2.2
20141030-#10344-asset-assignment-history	Vladimir Carevski	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:20.789176	468	EXECUTED	7:85a2e8a1b01613855662ae5616b0551f	createTable, addForeignKeyConstraint (x2), insert, sql, update	#10344 Implementing the asset assignment feature	\N	3.2.2
#10355 - reset password after expiry period	Bilal Shah	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:20.919866	469	EXECUTED	7:68f190ea4b1614612a893e12fe5e57d9	createTable		\N	3.2.2
20150307-missing-not-null-constraint	Vikas Bodani	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:20.935743	470	EXECUTED	7:c9267f9080df0cefd6cf3eec8330da71	addNotNullConstraint		\N	3.2.2
#8922-20150309-customer-price-active-expiry-date	Vikas Bodani	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:20.953117	471	EXECUTED	7:dbaf95d6034043e784fb1a86a90e9583	addColumn	Price subscription and expiration dates for customer price. Price expiration dates for Account Type price	\N	3.2.2
#10256:Asset Reservation scheduler plugin	Aman Goel	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:20.962588	472	EXECUTED	7:90aea8639ce31a2f7ac2f3ec125763cb	update		\N	3.2.2
#11369-Feature to identify inactive accounts	Aadil Nazir	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:20.986871	473	EXECUTED	7:0029c3ea1466b22e1614446811447527	addColumn, insert (x6)	#11369 Develop ability to identify inactive accounts\nAdded new column in base_user, value is set to date on which a user is marked in-active\nAdd new preference of Number of days after which a User's account will become inactive\nConstant ID may nee...	\N	3.2.2
#11369-Report for Feature to identify inactive accounts	Aadil Nazir	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:21.010651	474	EXECUTED	7:2d1c3191bac0f451e55b33913117f2c1	insert (x5)		\N	3.2.2
#10815-filter-key-data	Aman Goel	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:21.028373	475	EXECUTED	7:356b48eb7828a2853e02eafcf06bb88c	addColumn		\N	3.2.2
#12636-granting-user-credentials	Javier Rivero	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:21.258204	476	EXECUTED	7:ed963aa825b6157a3ec6bc956fd4b38c	insert (x3)		\N	3.2.2
#12702:Default credentials changed	Nelson Secchi	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:21.33155	477	EXECUTED	7:35065b00a050ae10ca0042bd16557ba3	insert (x3)	Description for the preference type, this is shown on the list of preferences	\N	3.2.2
#12702:Credentials email message notification	Nelson Secchi	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:21.365236	478	EXECUTED	7:783b49539fb94b3473a4a1d0da39b7ff	insert (x2)	We need a new message for when credentials are being created\nDefine the notification message type. For new entities, this id will be used on EntityDefaults	\N	3.2.2
#12686_Default_Security_Preferences:validation_rules	Fernando G. Morales	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:21.400051	479	EXECUTED	7:53dd8bd71fcea8b8569fce4179903be3	addColumn, addForeignKeyConstraint, insert (x4), update, insert (x4), update, insert (x4), update	Add validation rule to the preference type\nDefine validation rules and add to preferences\nSet rule for preference: Lock-out user after failed login attempts\nSet rule for preference: 'Expire user passwords after days'\nSet rule for preference: 'Expi...	\N	3.2.2
#12686_Default_Security_Preferences:remove_preferences	Fernando G. Morales	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:21.414557	480	EXECUTED	7:1883338c62a37c25051f10319d25f896	delete (x3)	Removed the HIDE CC CARD NUMBER preference	\N	3.2.2
#12686_Default_Security_Preferences:validation_rules for Telco-4.1	Nelson Secchi	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:21.431103	481	EXECUTED	7:e5405d4382d92d96ba131c215d32b5b4	update (x2)	Reverts the validation set for validation rule 69\nSet rule for preference: 'Expire Inactive Accounts After Days'\nThis assumes that the last changeset that added validations was #12686_Default_Security_Preferences:validation_rules	\N	3.2.2
#12602-audit-log-user-related-information	Bilal Shah	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:21.448678	482	EXECUTED	7:ece4e4787c89579d6f4d3559b3e10a19	insert (x6)		\N	3.2.2
#08072015	Ravi Singhal	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:21.457888	483	EXECUTED	7:b29f6452dfcfb3d951ab0707167fcafd	update		\N	3.2.2
#14013 Adding Asset reservation minute and it's validation	Vivek Yadav	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:21.473948	484	EXECUTED	7:00c17424aaffa96a0d0b97ef9d232db2	insert (x7)	Adding default reservation minute for asset reservation\nAdd validation rule for Asset reservation duration	\N	3.2.2
Removing PricingRuleTask	Manisha Gupta	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:21.484222	485	EXECUTED	7:07c5e70e759ab45d5e119af6ed5f2212	delete (x3)		\N	3.2.2
Removing Preferences for mediation, provisioning and ITG	Manisha Gupta	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:21.49699	486	EXECUTED	7:8341a3e69161ab22b689419a01f98f22	delete (x2)		\N	3.2.2
20151102-host-preferences	Web Data Technologies LLP	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:21.513653	487	EXECUTED	7:51e98da0c796456d0fbc687a7288aedf	createTable, insert		\N	3.2.2
jbilling-mediation-2.x-1	Web Data Technologies LLP	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:21.985282	488	EXECUTED	7:7c93a475100ee75099b4f42881c0adc1	createTable (x6), addForeignKeyConstraint (x8), insert (x42)	This table may exists because it may have gotten created from previous builds	\N	3.2.2
jbilling-mediation-2.x-2	Web Data Technologies LLP	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:22.309262	489	EXECUTED	7:aecc69c2dc8bbc1b1cd065a7a5004a9c	createTable, insert (x6), addColumn, modifyDataType, addColumn, update, insert, update, insert (x2)	This table may exists because it may have gotten created from previous builds	\N	3.2.2
#25012016- Add Plan Order line Type	Web Data Technologies LLP	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:22.334224	490	EXECUTED	7:4b13b06f970d0eee87d99009b185f2f8	insert (x2)		\N	3.2.2
1 Added missing jbilling-mediation-2.x-1	Web Data Technologies LLP	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:22.403963	491	EXECUTED	7:e4455b12767f5b86c666340c16a8308b	createIndex, insert		\N	3.2.2
20160118-add-percentage-datespecificprice	Web Data Technologies LLP	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:22.913604	492	EXECUTED	7:3751fa4264e3b67af5490ed02210bf83	addColumn (x2), insert, sql		\N	3.2.2
Chinese Translation Texts	Web Data Technologies LLP	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:23.194063	493	EXECUTED	7:08ad6ef3feca098d4e14163ce6b11bd1	insert, sql		\N	3.2.2
Creating new table for discount meta fields	Web Data Technologies LLP	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:23.290564	494	EXECUTED	7:13f7dae6425c1c2c3fe2af7f5749c14f	createTable, addForeignKeyConstraint (x2)		\N	3.2.2
sqlFile-update_jbilling_seqs	Web Data Technologies LLP	descriptors/database/jbilling-upgrade-4.1.xml	2016-11-13 21:00:23.626655	495	EXECUTED	7:350d3da4592feb02b32b92181ee5d2d8	sqlFile		\N	3.2.2
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
\.


--
-- Data for Name: discount; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discount (id, code, discount_type, rate, start_date, end_date, entity_id, last_update_datetime) FROM stdin;
\.


--
-- Data for Name: discount_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discount_attribute (discount_id, attribute_name, attribute_value) FROM stdin;
\.


--
-- Data for Name: discount_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discount_line (id, discount_id, item_id, order_id, discount_order_line_id, order_line_amount, description) FROM stdin;
\.


--
-- Data for Name: discount_meta_field_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discount_meta_field_map (discount_id, meta_field_value_id) FROM stdin;
\.


--
-- Data for Name: entity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entity (id, external_id, description, create_datetime, language_id, currency_id, optlock, deleted, invoice_as_reseller, parent_id) FROM stdin;
10	\N	ngecom	2016-11-13 21:49:46.833	1	1	1	0	f	\N
\.


--
-- Data for Name: entity_delivery_method_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entity_delivery_method_map (method_id, entity_id) FROM stdin;
1	10
2	10
3	10
\.


--
-- Data for Name: entity_payment_method_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entity_payment_method_map (entity_id, payment_method_id) FROM stdin;
10	1
10	2
10	3
\.


--
-- Data for Name: entity_report_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entity_report_map (report_id, entity_id) FROM stdin;
13	10
1	10
2	10
3	10
6	10
11	10
4	10
12	10
5	10
7	10
8	10
9	10
\.


--
-- Data for Name: enumeration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.enumeration (id, entity_id, name, optlock) FROM stdin;
10	10	ach.account.type	0
\.


--
-- Data for Name: enumeration_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.enumeration_values (id, enumeration_id, value, optlock) FROM stdin;
1000	10	CHECKING	0
1001	10	SAVINGS	0
\.


--
-- Data for Name: event_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_log (id, entity_id, user_id, table_id, foreign_id, create_datetime, level_field, module_id, message_id, old_num, old_str, old_date, optlock, affected_user_id) FROM stdin;
1000	10	10	10	10	2016-11-13 21:52:33.77	2	2	8	\N	\N	\N	0	10
1001	10	\N	10	10	2016-11-13 21:52:38.923	2	2	40	\N	admin	\N	0	10
1002	10	\N	10	10	2016-11-13 21:52:59.514	2	2	40	\N	admin	\N	0	10
1003	10	\N	10	10	2016-11-13 21:53:14.253	2	2	38	\N	admin	\N	0	10
1004	10	\N	10	10	2016-11-13 22:38:24.784	2	2	38	\N	admin	\N	0	10
1005	10	\N	10	10	2016-11-14 22:08:44.808	2	2	38	\N	admin	\N	0	10
1006	10	\N	10	10	2016-11-15 20:03:25.384	2	2	38	\N	admin	\N	0	10
1007	10	\N	10	10	2016-11-17 19:23:21.808	2	2	38	\N	admin	\N	0	10
1008	10	\N	10	10	2016-11-17 20:45:32.036	2	2	38	\N	admin	\N	0	10
1009	10	\N	10	10	2016-11-17 21:43:09.702	2	2	38	\N	admin	\N	0	10
2000	10	\N	10	10	2016-11-22 08:55:59.155	2	2	40	\N	admin	\N	0	10
2001	10	\N	10	10	2016-11-22 08:56:14.171	2	2	40	\N	admin	\N	0	10
2002	10	\N	10	10	2016-11-22 08:57:53.972	2	2	40	\N	admin	\N	0	10
2003	10	\N	10	10	2016-11-22 08:57:58.04	2	2	38	\N	admin	\N	0	10
2004	10	\N	10	10	2016-11-22 11:09:43.394	2	2	38	\N	admin	\N	0	10
2005	10	10	34	100	2016-11-22 11:10:05.169	2	1	9	\N	\N	\N	0	\N
3000	10	\N	10	10	2019-06-07 21:57:30.49	2	2	40	\N	admin	\N	0	10
3001	10	\N	10	10	2019-06-07 21:57:52.869	2	2	38	\N	admin	\N	0	10
3002	10	10	10	10	2019-06-07 21:59:54.683	2	2	8	\N	$2a$10$gAP5kR6koQ/0R.MjLxawxerhXtW7rxi.k.MtqRoF8SOsQyFJUMPwS	\N	0	10
3003	10	10	10	10	2019-06-07 21:59:54.968	2	2	9	\N	\N	\N	0	10
3004	10	\N	27	101	2019-06-07 21:59:55.059	2	2	9	\N	\N	\N	0	10
3005	10	\N	27	101	2019-06-07 21:59:55.113	2	2	9	\N	\N	\N	0	10
3006	10	\N	10	10	2019-06-07 22:01:09.13	2	2	39	\N	admin	\N	0	10
3007	10	\N	10	10	2019-06-07 22:01:18.576	2	2	40	\N	admin	\N	0	10
3008	10	\N	10	10	2019-06-07 22:01:29.504	2	2	38	\N	admin	\N	0	10
4000	10	\N	10	10	2019-06-07 22:04:22.206	2	2	38	\N	admin	\N	0	10
4001	10	\N	10	10	2019-06-07 22:04:38.565	2	2	39	\N	admin	\N	0	10
5000	10	\N	10	10	2019-06-08 16:11:54.147	2	2	38	\N	admin	\N	0	10
5001	10	\N	10	10	2019-06-08 16:12:05.722	2	2	39	\N	admin	\N	0	10
6000	10	\N	10	10	2019-06-09 13:59:33.507	2	2	38	\N	admin	\N	0	10
6001	10	\N	10	10	2019-06-09 14:30:10.671	2	2	38	\N	admin	\N	0	10
7000	10	\N	10	10	2019-06-10 21:31:02.692	2	2	40	\N	admin	\N	0	10
7001	10	\N	10	10	2019-06-10 21:31:18.056	2	2	38	\N	admin	\N	0	10
\.


--
-- Data for Name: event_log_message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_log_message (id) FROM stdin;
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
\.


--
-- Data for Name: event_log_module; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_log_module (id) FROM stdin;
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
\.


--
-- Data for Name: filter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.filter (id, filter_set_id, type, constraint_type, field, template, visible, integer_value, string_value, start_date_value, end_date_value, version, boolean_value, decimal_value, decimal_high_value, field_key_data) FROM stdin;
\.


--
-- Data for Name: filter_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.filter_set (id, name, user_id, version) FROM stdin;
\.


--
-- Data for Name: filter_set_filter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.filter_set_filter (filter_set_filters_id, filter_id, id) FROM stdin;
\.


--
-- Name: filter_set_filter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.filter_set_filter_id_seq', 1, false);


--
-- Data for Name: generic_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.generic_status (id, dtype, status_value, can_login, ordr, attribute1, entity_id, deleted) FROM stdin;
9	subscriber_status	1	\N	\N	\N	\N	\N
10	subscriber_status	2	\N	\N	\N	\N	\N
11	subscriber_status	3	\N	\N	\N	\N	\N
12	subscriber_status	4	\N	\N	\N	\N	\N
13	subscriber_status	5	\N	\N	\N	\N	\N
14	subscriber_status	6	\N	\N	\N	\N	\N
15	subscriber_status	7	\N	\N	\N	\N	\N
16	order_status	1	\N	\N	\N	\N	\N
17	order_status	2	\N	\N	\N	\N	\N
18	order_status	3	\N	\N	\N	\N	\N
19	order_status	4	\N	\N	\N	\N	\N
26	invoice_status	1	\N	\N	\N	\N	\N
27	invoice_status	2	\N	\N	\N	\N	\N
28	invoice_status	3	\N	\N	\N	\N	\N
33	process_run_status	1	\N	\N	\N	\N	\N
34	process_run_status	2	\N	\N	\N	\N	\N
35	process_run_status	3	\N	\N	\N	\N	\N
36	order_change_status	1	\N	0	NO	\N	0
37	order_change_status	2	\N	0	NO	\N	0
29	mediation_record_status	1	\N	\N	\N	\N	\N
30	mediation_record_status	2	\N	\N	\N	\N	\N
31	mediation_record_status	3	\N	\N	\N	\N	\N
32	mediation_record_status	4	\N	\N	\N	\N	\N
38	order_change_status	3	\N	1	YES	10	0
\.


--
-- Data for Name: generic_status_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.generic_status_type (id) FROM stdin;
order_status
subscriber_status
user_status
invoice_status
process_run_status
order_change_status
mediation_record_status
\.


--
-- Data for Name: international_description; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.international_description (table_id, foreign_id, psudo_column, language_id, content) FROM stdin;
17	5	description	1	All Orders
50	20	description	1	Manual invoice deletion
46	9	description	1	Invoice maintenance
46	11	description	1	Pluggable tasks maintenance
47	16	description	1	A purchase order as been manually applied to an invoice.
52	17	description	1	Payment (failed)
52	16	description	1	Payment (successful)
35	7	description	1	Diners
50	16	description	1	Days before expiration for order notification 2
50	17	description	1	Days before expiration for order notification 3
52	13	description	1	Order about to expire. Step 1
52	14	description	1	Order about to expire. Step 2
52	15	description	1	Order about to expire. Step 3
35	4	description	1	AMEX
35	5	description	1	ACH
50	14	description	1	Include customer notes in invoice
50	18	description	1	Invoice number prefix
64	234	description	1	Wallis and Futuna
64	235	description	1	Yemen
64	236	description	1	Zambia
64	237	description	1	Zimbabwe
50	15	description	1	Days before expiration for order notification
50	21	description	1	Use invoice reminders
50	22	description	1	Number of days after the invoice generation for the first reminder
50	23	description	1	Number of days for next reminder
64	227	description	1	Uzbekistan
64	147	description	1	Nauru
64	148	description	1	Nepal
64	149	description	1	Netherlands
64	150	description	1	Netherlands Antilles
64	151	description	1	New Caledonia
64	152	description	1	New Zealand
64	153	description	1	Nicaragua
64	154	description	1	Niger
64	155	description	1	Nigeria
64	156	description	1	Niue
64	157	description	1	Norfolk Island
64	158	description	1	North Korea
64	159	description	1	Northern Mariana Islands
64	160	description	1	Norway
64	161	description	1	Oman
64	162	description	1	Pakistan
64	163	description	1	Palau
64	164	description	1	Panama
64	165	description	1	Papua New Guinea
64	166	description	1	Paraguay
64	167	description	1	Peru
64	168	description	1	Philippines
64	169	description	1	Pitcairn Islands
64	170	description	1	Poland
64	171	description	1	Portugal
64	172	description	1	Puerto Rico
64	173	description	1	Qatar
64	174	description	1	Reunion
64	175	description	1	Romania
64	176	description	1	Russia
64	177	description	1	Rwanda
64	178	description	1	Samoa
64	179	description	1	San Marino
64	180	description	1	Sao Tome and Principe
64	181	description	1	Saudi Arabia
64	182	description	1	Senegal
64	183	description	1	Serbia and Montenegro
64	184	description	1	Seychelles
64	185	description	1	Sierra Leone
64	186	description	1	Singapore
64	187	description	1	Slovakia
64	188	description	1	Slovenia
64	189	description	1	Solomon Islands
64	190	description	1	Somalia
64	191	description	1	South Africa
64	192	description	1	South Georgia and the South Sandwich Islands
64	193	description	1	Spain
64	194	description	1	Sri Lanka
64	195	description	1	St. Helena
64	196	description	1	St. Kitts and Nevis
64	197	description	1	St. Lucia
64	198	description	1	St. Pierre and Miquelon
64	199	description	1	St. Vincent and the Grenadines
64	200	description	1	Sudan
64	201	description	1	Suriname
64	202	description	1	Svalbard and Jan Mayen
64	203	description	1	Swaziland
64	204	description	1	Sweden
64	205	description	1	Switzerland
64	206	description	1	Syria
64	207	description	1	Taiwan
64	208	description	1	Tajikistan
64	209	description	1	Tanzania
64	210	description	1	Thailand
64	211	description	1	Togo
64	212	description	1	Tokelau
64	213	description	1	Tonga
64	214	description	1	Trinidad and Tobago
64	215	description	1	Tunisia
64	216	description	1	Turkey
64	217	description	1	Turkmenistan
64	218	description	1	Turks and Caicos Islands
64	219	description	1	Tuvalu
64	220	description	1	Uganda
64	221	description	1	Ukraine
64	222	description	1	United Arab Emirates
64	223	description	1	United Kingdom
64	224	description	1	United States
64	225	description	1	United States Minor Outlying Islands
64	226	description	1	Uruguay
64	228	description	1	Vanuatu
64	229	description	1	Vatican City
64	230	description	1	Venezuela
64	231	description	1	Viet Nam
64	232	description	1	Virgin Islands - British
64	233	description	1	Virgin Islands
64	57	description	1	Congo - DRC
64	58	description	1	Denmark
64	59	description	1	Djibouti
64	60	description	1	Dominica
64	61	description	1	Dominican Republic
64	62	description	1	East Timor
64	63	description	1	Ecuador
64	64	description	1	Egypt
64	65	description	1	El Salvador
64	66	description	1	Equatorial Guinea
64	67	description	1	Eritrea
64	68	description	1	Estonia
64	69	description	1	Ethiopia
64	70	description	1	Malvinas Islands
64	71	description	1	Faroe Islands
64	72	description	1	Fiji Islands
64	73	description	1	Finland
64	74	description	1	France
64	75	description	1	French Guiana
64	76	description	1	French Polynesia
64	77	description	1	French Southern and Antarctic Lands
64	78	description	1	Gabon
64	79	description	1	Gambia
64	80	description	1	Georgia
64	81	description	1	Germany
64	82	description	1	Ghana
64	83	description	1	Gibraltar
64	84	description	1	Greece
64	85	description	1	Greenland
64	86	description	1	Grenada
64	87	description	1	Guadeloupe
64	88	description	1	Guam
64	89	description	1	Guatemala
64	90	description	1	Guinea
64	91	description	1	Guinea-Bissau
64	92	description	1	Guyana
64	93	description	1	Haiti
64	94	description	1	Heard Island and McDonald Islands
64	95	description	1	Honduras
64	96	description	1	Hong Kong SAR
64	97	description	1	Hungary
64	98	description	1	Iceland
64	99	description	1	India
64	100	description	1	Indonesia
64	101	description	1	Iran
64	102	description	1	Iraq
64	103	description	1	Ireland
64	104	description	1	Israel
64	105	description	1	Italy
64	106	description	1	Jamaica
64	107	description	1	Japan
64	108	description	1	Jordan
64	109	description	1	Kazakhstan
64	110	description	1	Kenya
64	111	description	1	Kiribati
64	112	description	1	Korea
64	113	description	1	Kuwait
64	114	description	1	Kyrgyzstan
64	115	description	1	Laos
64	116	description	1	Latvia
64	117	description	1	Lebanon
64	118	description	1	Lesotho
64	119	description	1	Liberia
64	120	description	1	Libya
64	121	description	1	Liechtenstein
64	122	description	1	Lithuania
64	123	description	1	Luxembourg
64	124	description	1	Macao SAR
64	125	description	1	Macedonia, Former Yugoslav Republic of
64	126	description	1	Madagascar
64	127	description	1	Malawi
64	128	description	1	Malaysia
64	129	description	1	Maldives
64	130	description	1	Mali
64	131	description	1	Malta
64	132	description	1	Marshall Islands
64	133	description	1	Martinique
64	134	description	1	Mauritania
64	135	description	1	Mauritius
64	136	description	1	Mayotte
64	137	description	1	Mexico
64	138	description	1	Micronesia
64	139	description	1	Moldova
64	140	description	1	Monaco
64	141	description	1	Mongolia
64	142	description	1	Montserrat
64	143	description	1	Morocco
64	144	description	1	Mozambique
64	145	description	1	Myanmar
64	146	description	1	Namibia
64	1	description	1	Afghanistan
64	2	description	1	Albania
64	3	description	1	Algeria
64	4	description	1	American Samoa
64	5	description	1	Andorra
64	6	description	1	Angola
64	7	description	1	Anguilla
64	8	description	1	Antarctica
64	9	description	1	Antigua and Barbuda
64	10	description	1	Argentina
64	11	description	1	Armenia
64	12	description	1	Aruba
64	13	description	1	Australia
64	14	description	1	Austria
64	15	description	1	Azerbaijan
64	16	description	1	Bahamas
64	17	description	1	Bahrain
64	18	description	1	Bangladesh
64	19	description	1	Barbados
64	20	description	1	Belarus
64	21	description	1	Belgium
64	22	description	1	Belize
64	23	description	1	Benin
64	24	description	1	Bermuda
64	25	description	1	Bhutan
64	26	description	1	Bolivia
64	27	description	1	Bosnia and Herzegovina
64	28	description	1	Botswana
64	29	description	1	Bouvet Island
64	30	description	1	Brazil
64	31	description	1	British Indian Ocean Territory
64	32	description	1	Brunei
64	33	description	1	Bulgaria
64	34	description	1	Burkina Faso
64	35	description	1	Burundi
64	36	description	1	Cambodia
64	37	description	1	Cameroon
64	38	description	1	Canada
64	39	description	1	Cape Verde
64	40	description	1	Cayman Islands
64	41	description	1	Central African Republic
64	42	description	1	Chad
64	43	description	1	Chile
64	44	description	1	China
64	45	description	1	Christmas Island
64	46	description	1	Cocos - Keeling Islands
64	47	description	1	Colombia
64	48	description	1	Comoros
64	49	description	1	Congo
64	50	description	1	Cook Islands
64	51	description	1	Costa Rica
64	52	description	1	Cote d Ivoire
64	53	description	1	Croatia
64	54	description	1	Cuba
64	55	description	1	Cyprus
64	56	description	1	Czech Republic
4	1	description	1	United States Dollar
4	2	description	1	Canadian Dollar
4	3	description	1	Euro
4	4	description	1	Yen
4	5	description	1	Pound Sterling
4	6	description	1	Won
4	7	description	1	Swiss Franc
4	8	description	1	Swedish Krona
6	1	description	1	Month
6	2	description	1	Week
6	3	description	1	Day
6	4	description	1	Year
7	1	description	1	Email
7	2	description	1	Paper
9	1	description	1	Active
60	10	description	1	The super user of an entity
60	10	title	1	Super user
60	11	description	1	A billing clerk
60	11	title	1	Clerk
60	13	description	1	A agent that will bring customers
60	13	title	1	Agent
114	16	errorMessage	1	Email Validation error
81	1	description	1	Active
81	2	description	1	Pending Unsubscription
81	3	description	1	Unsubscribed
81	4	description	1	Pending Expiration
81	5	description	1	Expired
81	6	description	1	Nonsubscriber
81	7	description	1	Discontinued
60	1	description	1	An internal user with all the permissions
60	1	title	1	Internal
60	2	description	1	The super user of an entity
60	2	title	1	Super user
60	3	description	1	A billing clerk
60	3	title	1	Clerk
60	5	description	1	A customer that will query his/her account
60	5	title	1	Customer
17	1	description	1	One time
18	1	description	1	Items
18	2	description	1	Tax
19	1	description	1	pre paid
19	2	description	1	post paid
20	1	description	1	Active
20	2	description	1	Finished
20	3	description	1	Suspended
35	1	description	1	Cheque
35	2	description	1	Visa
35	3	description	1	MasterCard
41	1	description	1	Successful
41	2	description	1	Failed
41	3	description	1	Processor unavailable
41	4	description	1	Entered
46	1	description	1	Billing Process
46	2	description	1	User maintenance
46	3	description	1	Item maintenance
46	4	description	1	Item type maintenance
46	5	description	1	Item user price maintenance
46	6	description	1	Promotion maintenance
46	7	description	1	Order maintenance
46	8	description	1	Credit card maintenance
47	1	description	1	A prepaid order has unbilled time before the billing process date
47	2	description	1	Order has no active time at the date of process.
47	3	description	1	At least one complete period has to be billable.
47	4	description	1	Already billed for the current date.
47	5	description	1	This order had to be maked for exclusion in the last process.
47	6	description	1	Pre-paid order is being process after its expiration.
47	7	description	1	A row was marked as deleted.
47	8	description	1	A user password was changed.
47	9	description	1	A row was updated.
47	10	description	1	Running a billing process, but a review is found unapproved.
47	11	description	1	Running a billing process, review is required but not present.
47	12	description	1	A user status was changed.
47	13	description	1	An order status was changed.
47	14	description	1	A user had to be aged, but there's no more steps configured.
47	15	description	1	A partner has a payout ready, but no payment instrument.
50	1	description	1	Process payment with billing process
50	2	description	1	URL of CSS file
50	3	description	1	URL of logo graphic
50	4	description	1	Grace period
50	13	description	1	Self delivery of paper invoices
52	1	description	1	Invoice (email)
52	2	description	1	User Reactivated
60	4	title	1	Agent
60	4	description	1	A agent that will bring customers
52	3	description	1	User Overdue
52	4	description	1	User Overdue 2
52	5	description	1	User Overdue 3
52	6	description	1	User Suspended
52	7	description	1	User Suspended 2
52	8	description	1	User Suspended 3
52	9	description	1	User Deleted
52	12	description	1	Invoice (paper)
50	24	description	1	Data Fattura Fine Mese
4	9	description	1	Singapore Dollar
4	10	description	1	Malaysian Ringgit
4	11	description	1	Australian Dollar
50	19	description	1	Next invoice number
7	3	description	1	Email + Paper
35	8	description	1	PayPal
52	19	description	1	Update Credit Card
20	4	description	1	Suspended (auto)
18	3	description	1	Penalty
52	20	description	1	Lost password
88	1	description	1	Active
88	2	description	1	Inactive
88	3	description	1	Pending Active
88	4	description	1	Pending Inactive
88	5	description	1	Failed
88	6	description	1	Unavailable
50	20	description	2	Eliminação manual de facturas
46	9	description	2	Manutenção de facturas
46	11	description	2	Manutenção de tarefas de plug-ins
47	16	description	2	Uma ordem de compra foi aplicada manualmente a uma factura.
52	17	description	2	Payment (sem sucesso)
52	16	description	2	Payment (com sucesso)
60	12	description	1	A customer that will query his/her account
35	7	description	2	Diners
50	16	description	2	Dias antes da expiração para notificação de ordens 2
50	17	description	2	Dias antes da expiração para notificação de ordens 3
52	13	description	2	Ordem de compra a expirar. Passo 1
52	14	description	2	Ordem de compra a expirar. Passo 2
52	15	description	2	Ordem de compra a expirar. Passo 3
35	4	description	2	AMEX
35	5	description	2	CCA
50	14	description	2	Incluir notas do cliente na factura
50	18	description	2	NÚmero de prefixo da factura
64	234	description	2	Wallis and Futuna
64	235	description	2	Yemen
64	236	description	2	Zâmbia
64	237	description	2	Zimbabwe
50	15	description	2	Dias antes da expiração para notificação de ordens
50	21	description	2	Usar os lembretes de factura
50	22	description	2	NÚmero de dias após a geração da factura para o primeiro lembrete
50	23	description	2	NÚmero de dias para o próximo lembrete
64	227	description	2	Uzbekistão
64	147	description	2	Nauru
64	148	description	2	Nepal
64	149	description	2	Holanda
64	150	description	2	Antilhas Holandesas
64	151	description	2	Nova Caledônia
64	152	description	2	Nova Zelândia
64	153	description	2	Nicarágua
64	154	description	2	Niger
64	155	description	2	Nigéria
64	156	description	2	Niue
64	157	description	2	Ilhas Norfolk
64	158	description	2	Coreia do Norte
64	159	description	2	Ilhas Mariana do Norte
64	160	description	2	Noruega
64	161	description	2	Oman
64	162	description	2	Pakistão
64	163	description	2	Palau
64	164	description	2	Panama
64	165	description	2	Papua Nova Guiné
64	166	description	2	Paraguai
64	167	description	2	Perú
64	168	description	2	Filipinas
64	169	description	2	Ilhas Pitcairn
64	170	description	2	Polônia
64	171	description	2	Portugal
64	172	description	2	Porto Rico
64	173	description	2	Qatar
64	174	description	2	Reunião
64	175	description	2	Romênia
64	176	description	2	Rússia
64	177	description	2	Rwanda
64	178	description	2	Samoa
64	179	description	2	São Marino
64	180	description	2	São Tomé e Princepe
64	181	description	2	Arábia Saudita
64	182	description	2	Senegal
64	183	description	2	Sérvia e Montenegro
64	184	description	2	Seychelles
64	185	description	2	Serra Leoa
64	186	description	2	Singapure
64	187	description	2	Eslováquia
64	188	description	2	Eslovenia
64	189	description	2	Ilhas Salomão
64	190	description	2	Somália
64	191	description	2	África do Sul
64	192	description	2	Georgia do Sul e Ilhas Sandwich South
64	193	description	2	Espanha
64	194	description	2	Sri Lanka
64	195	description	2	Sta. Helena
64	196	description	2	Sta. Kitts e Nevis
64	197	description	2	Sta. Lucia
64	198	description	2	Sta. Pierre e Miquelon
64	199	description	2	Sto. Vicente e Grenadines
64	200	description	2	Sudão
64	201	description	2	Suriname
64	202	description	2	Svalbard e Jan Mayen
64	203	description	2	Suazilândia
64	204	description	2	Suécia
64	205	description	2	Suíça
64	206	description	2	Síria
64	207	description	2	Taiwan
64	208	description	2	Tajikistão
64	209	description	2	Tanzânia
64	210	description	2	Tailândia
64	211	description	2	Togo
64	212	description	2	Tokelau
64	213	description	2	Tonga
64	214	description	2	Trinidade e Tobago
64	215	description	2	Tunísia
64	216	description	2	Turquia
64	217	description	2	Turkmenistão
64	218	description	2	Ilhas Turks e Caicos
64	219	description	2	Tuvalu
64	220	description	2	Uganda
64	221	description	2	Ucrânia
64	222	description	2	Emiados Árabes Unidos
64	223	description	2	Reino Unido
64	224	description	2	Estados Unidos
64	225	description	2	Estados Unidos e Ilhas Menores Circundantes
64	226	description	2	Uruguai
64	228	description	2	Vanuatu
64	229	description	2	Cidade do Vaticano
64	230	description	2	Venezuela
64	231	description	2	Vietname
64	232	description	2	Ilhas Virgens Britânicas
64	233	description	2	Ilhas Virgens
64	57	description	2	República Democrática do Congo
64	58	description	2	Dinamarca
64	59	description	2	Djibouti
64	60	description	2	Dominica
64	61	description	2	República Dominicana
64	62	description	2	Timor Leste
64	63	description	2	Ecuador
64	64	description	2	Egipto
64	65	description	2	El Salvador
64	66	description	2	Guiné Equatorial
64	67	description	2	Eritreia
64	68	description	2	Estônia
64	69	description	2	Etiopia
64	70	description	2	Ilhas Malvinas
64	71	description	2	Ilhas Faroé
64	72	description	2	Ilhas Fiji
64	73	description	2	Finlândia
64	74	description	2	França
64	75	description	2	Guiana Francesa
64	76	description	2	Polinésia Francesa
64	77	description	2	Terras Antárticas e do Sul Francesas
64	78	description	2	Gabão
64	79	description	2	Gâmbia
64	80	description	2	Georgia
64	81	description	2	Alemanha
64	82	description	2	Gana
64	83	description	2	Gibraltar
64	84	description	2	Grécia
64	85	description	2	Gronelândia
64	86	description	2	Granada
64	87	description	2	Guadalupe
64	88	description	2	Guantanamo
64	89	description	2	Guatemala
64	90	description	2	Guiné
64	91	description	2	Guiné-Bissau
64	92	description	2	Guiana
64	93	description	2	Haiti
64	94	description	2	Ilhas Heard e McDonald
64	95	description	2	Honduras
64	96	description	2	Hong Kong SAR
64	97	description	2	Hungria
64	98	description	2	Islândia
64	99	description	2	Índia
64	100	description	2	Indonésia
64	101	description	2	Irâo
64	102	description	2	Iraque
64	103	description	2	Irlanda
64	104	description	2	Israel
64	105	description	2	Itália
64	106	description	2	Jamaica
64	107	description	2	Japão
64	108	description	2	Jordânia
64	109	description	2	Kazaquistão
64	110	description	2	Kênia
64	111	description	2	Kiribati
64	112	description	2	Coreia
64	113	description	2	Kuwait
64	114	description	2	Kirgistão
64	115	description	2	Laos
64	116	description	2	Latvia
64	117	description	2	Líbano
64	118	description	2	Lesoto
64	119	description	2	Libéria
64	120	description	2	Líbia
64	121	description	2	Liechtenstein
64	122	description	2	Lituânia
64	123	description	2	Luxemburgo
64	124	description	2	Macau SAR
64	125	description	2	Macedónia, Antiga República Jugoslava da
64	126	description	2	Madagáscar
64	127	description	2	Malaui
64	128	description	2	Malásia
64	129	description	2	Maldivas
64	130	description	2	Mali
64	131	description	2	Malta
64	132	description	2	Ilhas Marshall
64	133	description	2	Martinica
64	134	description	2	Mauritânia
64	135	description	2	Maurícias
64	136	description	2	Maiote
64	137	description	2	México
64	138	description	2	Micronésia
64	139	description	2	Moldova
64	140	description	2	Mônaco
64	141	description	2	Mongólia
64	142	description	2	Monserrate
64	143	description	2	Marrocos
64	144	description	2	Moçambique
64	145	description	2	Mianmar
64	146	description	2	Namíbia
64	1	description	2	Afganistão
64	2	description	2	Albânia
64	3	description	2	Algéria
64	4	description	2	Samoa Americana
64	5	description	2	Andorra
64	6	description	2	Angola
64	7	description	2	Anguilha
64	8	description	2	Antártida
64	9	description	2	Antigua e Barbuda
64	10	description	2	Argentina
64	11	description	2	Armênia
64	12	description	2	Aruba
64	13	description	2	Austrália
64	14	description	2	Áustria
64	15	description	2	Azerbaijão
64	16	description	2	Bahamas
64	17	description	2	Bahrain
64	18	description	2	Bangladesh
64	19	description	2	Barbados
64	20	description	2	Belarus
64	21	description	2	Bélgica
64	22	description	2	Belize
64	23	description	2	Benin
64	24	description	2	Bermuda
64	25	description	2	Butão
64	26	description	2	Bolívia
64	27	description	2	Bosnia e Herzegovina
64	28	description	2	Botswana
64	29	description	2	Ilha Bouvet
64	30	description	2	Brasil
64	31	description	2	Território Britânico do Oceano Índico
64	32	description	2	Brunei
64	33	description	2	Bulgária
64	34	description	2	Burquina Faso
64	35	description	2	Burundi
64	36	description	2	Cambodia
64	37	description	2	Camarões
64	38	description	2	Canada
64	39	description	2	Cabo Verde
64	40	description	2	Ilhas Caimáo
64	41	description	2	República Centro Africana
64	42	description	2	Chade
64	43	description	2	Chile
64	44	description	2	China
64	45	description	2	Ilha Natal
64	46	description	2	Ilha Cocos e Keeling
64	47	description	2	Colômbia
64	48	description	2	Comoros
64	49	description	2	Congo
64	50	description	2	Ilhas Cook
64	51	description	2	Costa Rica
64	52	description	2	Costa do Marfim
64	53	description	2	Croácia
64	54	description	2	Cuba
64	55	description	2	Chipre
64	56	description	2	República Checa
4	1	description	2	DÓlares Norte Americanos
4	2	description	2	DÓlares Canadianos
4	3	description	2	Euro
4	4	description	2	Ien
4	5	description	2	Libras Estrelinas
4	6	description	2	Won
4	7	description	2	Franco Suíço
4	8	description	2	Coroa Sueca
6	1	description	2	Mês
6	2	description	2	Semana
6	3	description	2	Dia
6	4	description	2	Ano
7	1	description	2	Email
7	2	description	2	Papel
9	1	description	2	Activo
60	12	title	1	Customer
112	10	description	1	Contact
60	1	description	2	Um utilizador interno com todas as permissões
60	1	title	2	Interno
60	2	description	2	O super utilizador de uma entidade
60	2	title	2	Super utilizador
60	3	description	2	Um operador de facturação
60	3	title	2	Operador
60	4	description	2	Um parceiro que vai angariar clientes
60	4	title	2	Parceiro
60	5	description	2	Um cliente que vai fazer pesquisas na sua conta
60	5	title	2	Cliente
17	1	description	2	uma vez
18	1	description	2	Items
18	2	description	2	Imposto
19	1	description	2	Pré pago
19	2	description	2	Pós pago
20	1	description	2	Activo
20	2	description	2	Terminado
20	3	description	2	Suspenso
35	1	description	2	Cheque
35	2	description	2	Visa
35	3	description	2	MasterCard
41	1	description	2	Com sucesso
41	2	description	2	Sem sucesso
41	3	description	2	Processador indisponível
41	4	description	2	Inserido
46	1	description	2	Processo de facturação
46	2	description	2	Manutenção de Utilizador
46	3	description	2	Item de Manutenção
46	4	description	2	Item tipo de Manutenção
46	5	description	2	Item Manutenção de preço de utilizador
46	6	description	2	Manutenção de promoção
46	7	description	2	Manutenção por ordem
46	8	description	2	Manutenção de cartão de crédito
47	1	description	2	Uma ordem prê-paga tem tempo não facturado anterior data de facturação
47	2	description	2	A ordem não tem nenhum período activo data de processamento.
47	3	description	2	Pelo menos um período completo tem de ser facturável.
47	4	description	2	Já há facturação para o período.
47	5	description	2	Esta ordem teve de ser marcada para exclusão do último processo.
47	6	description	2	Pre-paid order is being process after its expiration.
47	7	description	2	A linha marcada foi eliminada.
47	8	description	2	A senha de utilizador foi alterada.
47	9	description	2	Uma linha foi actualizada.
47	10	description	2	A correr um processo de facturação, foi encontrada uma revisão rejeitada.
47	11	description	2	A correr um processo de facturação, uma necessária mas não encontrada.
47	12	description	2	Um status de utilizador foi alterado.
47	13	description	2	Um status de uma ordem foi alterado.
47	14	description	2	Um utilizador foi inserido no processo de antiguidade, mas não há mais passos configurados.
47	15	description	2	Um parceiro tem um pagamento a receber, mas não tem instrumento de pagamento.
50	1	description	2	Processar pagamento com processo de facturação
50	2	description	2	URL ou ficheiro CSS
50	3	description	2	URL ou gráfico de logotipo
50	4	description	2	Período de graça
20	100	description	1	Active
20	101	description	1	Finished
20	102	description	1	Suspended
20	103	description	1	Suspended ageing(auto)
17	100	description	1	Monthly
115	3	description	1	Default (Apply)
111	101	description	1	Private
50	13	description	2	Entrega pelo mesmo das facturas em papel
52	1	description	2	Factura (email)
52	2	description	2	Utilizador Reactivado
52	3	description	2	Utilizador Em Atraso
52	4	description	2	Utilizador Em Atraso 2
52	5	description	2	Utilizador Em Atraso 3
52	6	description	2	Utilizador Suspenso
52	7	description	2	Utilizador Suspenso 2
52	8	description	2	Utilizador Suspenso 3
52	9	description	2	Utilizador Eliminado
52	10	description	2	Pagamento Remascente
52	11	description	2	Parceiro Pagamento
52	12	description	2	Factura (papel)
50	24	description	2	Data Factura Fim do Mês
4	9	description	2	DÓlar da Singapura
4	10	description	2	Ringgit Malasiano
4	11	description	2	DÓlar Australiano
50	19	description	2	próximo NÚmero de factura
7	3	description	2	Email + Papel
35	8	description	2	PayPal
52	19	description	2	Actualizar cartão de crédito
20	4	description	2	Suspender (auto)
18	3	description	2	Penalidade
52	20	description	2	Senha esquecida
89	1	description	1	None
89	2	description	1	Pre-paid balance
89	3	description	1	Credit limit
91	1	description	1	Done and billable
91	2	description	1	Done and not billable
91	3	description	1	Error detected
91	4	description	1	Error declared
92	1	description	1	Running
92	2	description	1	Finished: successful
92	3	description	1	Finished: failed
23	1	description	1	Item management and order line total calculation
23	2	description	1	Billing process: order filters
23	3	description	1	Billing process: invoice filters
23	4	description	1	Invoice presentation
23	5	description	1	Billing process: order periods calculation
23	6	description	1	Payment gateway integration
23	7	description	1	Notifications
23	8	description	1	Payment instrument selection
23	9	description	1	Penalties for overdue invoices
23	10	description	1	Alarms when a payment gateway is down
23	11	description	1	Subscription status manager
23	12	description	1	Parameters for asynchronous payment processing
23	13	description	1	Add one product to order
23	14	description	1	Product pricing
23	17	description	1	Generic internal events listener
23	19	description	1	Purchase validation against pre-paid balance / credit limit
23	20	description	1	Billing process: customer selection
23	22	description	1	Scheduled Plug-ins
23	23	description	1	Rules Generators
23	24	description	1	Ageing for customers with overdue invoices
24	1	title	1	Default order totals
24	1	description	1	Calculates the order total and the total for each line, considering the item prices, the quantity and if the prices are percentage or not.
24	2	title	1	VAT
24	2	description	1	Adds an additional line to the order with a percentage charge to represent the value added tax.
24	3	title	1	Invoice due date
24	3	description	1	A very simple implementation that sets the due date of the invoice. The due date is calculated by just adding the period of time to the invoice date.
24	4	title	1	Default invoice composition.
24	4	description	1	This task will copy all the lines on the orders and invoices to the new invoice, considering the periods involved for each order, but not the fractions of periods. It will not copy the lines that are taxes. The quantity and total of each line will be multiplied by the amount of periods.
24	5	title	1	Standard Order Filter
24	5	description	1	Decides if an order should be included in an invoice for a given billing process.  This is done by taking the billing process time span, the order period, the active since/until, etc.
24	6	title	1	Standard Invoice Filter
24	6	description	1	Always returns true, meaning that the overdue invoice will be carried over to a new invoice.
24	7	title	1	Default Order Periods
24	7	description	1	Calculates the start and end period to be included in an invoice. This is done by taking the billing process time span, the order period, the active since/until, etc.
24	8	title	1	Authorize.net payment processor
24	8	description	1	Integration with the authorize.net payment gateway.
111	0	description	1	Business
24	9	title	1	Standard Email Notification
24	9	description	1	Notifies a user by sending an email. It supports text and HTML emails
24	10	title	1	Default payment information
24	10	description	1	Finds the information of a payment method available to a customer, given priority to credit card. In other words, it will return the credit car of a customer or the ACH information in that order.
24	11	title	1	Testing plug-in for partner payouts
24	11	description	1	Plug-in useful only for testing
24	12	title	1	PDF invoice notification
24	12	description	1	Will generate a PDF version of an invoice.
24	14	title	1	No invoice carry over
24	14	description	1	Returns always false, which makes jBilling to never carry over an invoice into another newer invoice.
24	15	title	1	Default interest task
101	1	description	1	Invoice Reports
24	15	description	1	Will create a new order with a penalty item. The item is taken as a parameter to the task.
24	16	title	1	Anticipated order filter
24	16	description	1	Extends BasicOrderFilterTask, modifying the dates to make the order applicable a number of months before it would be by using the default filter.
24	17	title	1	Anticipate order periods.
24	17	description	1	Extends BasicOrderPeriodTask, modifying the dates to make the order applicable a number of months before itd be by using the default task.
24	19	title	1	Email & process authorize.net
24	19	description	1	Extends the standard authorize.net payment processor to also send an email to the company after processing the payment.
24	20	title	1	Payment gateway down alarm
24	20	description	1	Sends an email to the billing administrator as an alarm when a payment gateway is down.
24	21	title	1	Test payment processor
24	21	description	1	A test payment processor implementation to be able to test jBillings functions without using a real payment gateway.
24	22	title	1	Router payment processor based on Custom Fields
24	22	description	1	Allows a customer to be assigned a specific payment gateway. It checks a custom contact field to identify the gateway and then delegates the actual payment processing to another plugin.
24	23	title	1	Default subscription status manager
24	23	description	1	It determines how a payment event affects the subscription status of a user, considering its present status and a state machine.
24	24	title	1	ACH Commerce payment processor
24	24	description	1	Integration with the ACH commerce payment gateway.
24	25	title	1	Standard asynchronous parameters
24	25	description	1	A dummy task that does not add any parameters for asynchronous payment processing. This is the default.
24	26	title	1	Router asynchronous parameters
24	26	description	1	This plug-in adds parameters for asynchronous payment processing to have one processing message bean per payment processor. It is used in combination with the router payment processor plug-ins.
24	28	title	1	Standard Item Manager
24	28	description	1	It adds items to an order. If the item is already in the order, it only updates the quantity.
24	29	title	1	Rules Item Manager
24	29	description	1	This is a rules-based plug-in. It will do what the basic item manager does (actually calling it); but then it will execute external rules as well. These external rules have full control on changing the order that is getting new items.
24	30	title	1	Rules Line Total
24	30	description	1	This is a rules-based plug-in. It calculates the total for an order line (typically this is the price multiplied by the quantity); allowing for the execution of external rules.
24	31	title	1	Rules Pricing
24	35	title	1	Payment information without validation
24	35	description	1	This is exactly the same as the standard payment information task, the only difference is that it does not validate if the credit card is expired. Use this plug-in only if you want to submit payment with expired credit cards.
24	36	title	1	Notification task for testing
24	36	description	1	This plug-in is only used for testing purposes. Instead of sending an email (or other real notification); it simply stores the text to be sent in a file named emails_sent.txt.
24	37	title	1	Order periods calculator with pro rating.
24	37	description	1	This plugin takes into consideration the field cycle starts of orders to calculate fractional order periods.
24	38	title	1	Invoice composition task with pro-rating (day as fraction)
24	38	description	1	When creating an invoice from an order, this plug-in will pro-rate any fraction of a period taking a day as the smallest billable unit.
24	39	title	1	Payment process for the Intraanuity payment gateway
24	39	description	1	Integration with the Intraanuity payment gateway.
24	40	title	1	Automatic cancellation credit.
24	40	description	1	This plug-in will create a new order with a negative price to reflect a credit when an order is canceled within a period that has been already invoiced.
111	100	description	1	Basic
24	42	title	1	Blacklist filter payment processor.
24	42	description	1	Used for blocking payments from reaching real payment processors. Typically configured as first payment processor in the processing chain.
24	43	title	1	Blacklist user when their status becomes suspended or higher.
24	43	description	1	Causes users and their associated details (e.g., credit card number, phone number, etc.) to be blacklisted when their status becomes suspended or higher. 
24	49	title	1	Currency Router payment processor
24	49	description	1	Delegates the actual payment processing to another plug-in based on the currency of the payment.
24	51	title	1	Filters out negative invoices for carry over.
24	51	description	1	This filter will only invoices with a positive balance to be carried over to the next invoice.
114	17	errorMessage	1	Email is mandatory
24	52	title	1	File invoice exporter.
24	52	description	1	It will generate a file with one line per invoice generated.
24	53	title	1	Rules caller on an event.
24	53	description	1	It will call a package of rules when an internal event happens.
24	54	title	1	Dynamic balance manager
24	54	description	1	It will update the dynamic balance of a customer (pre-paid or credit limit) when events affecting the balance happen.
24	55	title	1	Balance validator based on the customer balance.
24	55	description	1	Used for real-time mediation, this plug-in will validate a call based on the current dynamic balance of a customer.
24	56	title	1	Balance validator based on rules.
24	56	description	1	Used for real-time mediation, this plug-in will validate a call based on a package or rules
24	57	title	1	Payment processor for Payments Gateway.
24	57	description	1	Integration with the Payments Gateway payment processor.
101	2	description	1	Order Reports
24	58	title	1	Credit cards are stored externally.
24	58	description	1	Saves the credit card information in the payment gateway, rather than the jBilling DB.
24	59	title	1	Rules Item Manager 2
24	59	description	1	This is a rules-based plug-in compatible with the mediation module of jBilling 2.2.x. It will do what the basic item manager does (actually calling it); but then it will execute external rules as well. These external rules have full control on changing the order that is getting new items.
24	60	title	1	Rules Line Total - 2
24	60	description	1	This is a rules-based plug-in, compatible with the mediation process of jBilling 2.2.x and later. It calculates the total for an order line (typically this is the price multiplied by the quantity); allowing for the execution of external rules.
24	61	title	1	Rules Pricing 2
24	61	description	1	This is a rules-based plug-in compatible with the mediation module of jBilling 2.2.x. It gives a price to an item by executing external rules. You can then add logic externally for pricing. It is also integrated with the mediation process by having access to the mediation pricing data.
24	63	title	1	Test payment processor for external storage.
24	63	description	1	A fake plug-in to test payments that would be stored externally.
24	64	title	1	WorldPay integration
24	64	description	1	Payment processor plug-in to integrate with RBS WorldPay
24	65	title	1	WorldPay integration with external storage
24	65	description	1	Payment processor plug-in to integrate with RBS WorldPay. It stores the credit card information (number, etc) in the gateway.
24	66	title	1	Auto recharge
24	66	description	1	Monitors the balance of a customer and upon reaching a limit, it requests a real-time payment
24	67	title	1	Beanstream gateway integration
24	67	description	1	Payment processor for integration with the Beanstream payment gateway
24	68	title	1	Sage payments gateway integration
24	68	description	1	Payment processor for integration with the Sage payment gateway
24	69	title	1	Standard billing process users filter
24	69	description	1	Called when the billing process runs to select which users to evaluate. This basic implementation simply returns every user not in suspended (or worse) status
24	70	title	1	Selective billing process users filter
24	70	description	1	Called when the billing process runs to select which users to evaluate. This only returns users with orders that have a next invoice date earlier than the billing process.
24	71	title	1	Mediation file error handler
24	71	description	1	Event records with errors are saved to a file
24	73	title	1	Mediation data base error handler
24	73	description	1	Event records with errors are saved to a database table
24	75	title	1	Paypal integration with external storage
24	75	description	1	Submits payments to paypal as a payment gateway and stores credit card information in PayPal as well
24	76	title	1	Authorize.net integration with external storage
24	76	description	1	Submits payments to authorize.net as a payment gateway and stores credit card information in authorize.net as well
24	77	title	1	Payment method router payment processor
24	77	description	1	Delegates the actual payment processing to another plug-in based on the payment method of the payment.
24	78	title	1	Dynamic rules generator
24	78	description	1	Generates rules dynamically based on a Velocity template.
24	80	title	1	Billing Process Task
24	80	description	1	A scheduled task to execute the Billing Process.
24	87	title	1	Basic ageing
24	87	description	1	Ages a user based on the number of days that the account is overdue.
24	88	title	1	Ageing process task
24	88	description	1	A scheduled task to execute the Ageing Process.
24	89	title	1	Business day ageing
24	89	description	1	Ages a user based on the number of business days (excluding holidays) that the account is overdue.
24	90	title	1	Simple Tax Composition Task
24	90	description	1	A pluggable task of the type AbstractChargeTask to apply tax item to an Invoice with a facility of exempting an exempt item or an exemp customer.
24	91	title	1	Country Tax Invoice Composition Task
24	91	description	1	A pluggable task of the type AbstractChargeTask to apply tax item to the Invoice if the Partner's country code is matching.
24	92	title	1	Payment Terms Penalty Task
24	92	description	1	A pluggable task of the type AbstractChargeTask to apply a Penalty to an Invoice having a due date beyond a configurable days period.
114	10	errorMessage	1	Payment card number is not valid
114	11	errorMessage	1	Expiry date should be in format MM/yyyy
47	17	description	1	The order line has been updated
47	18	description	1	The order next billing date has been changed
35	1	description	3	Scheck
111	102	description	1	Business
47	19	description	1	Last API call to get the the user subscription status transitions
47	20	description	1	User subscription status has changed
47	21	description	1	User account is now locked
47	22	description	1	The order main subscription flag was changed
47	23	description	1	All the one-time orders the mediation found were in status finished
47	24	description	1	A valid payment method was not found. The payment request was cancelled
47	25	description	1	A new row has been created
47	26	description	1	An invoiced order was cancelled, a credit order was created
47	27	description	1	A user id was added to the blacklist
47	28	description	1	A user id was removed from the blacklist
47	32	description	1	User subscription status has NOT changed
47	33	description	1	The dynamic balance of a user has changed
47	34	description	1	The invoice if child flag has changed
101	3	description	1	Payment Reports
101	4	description	1	Customer Reports
100	1	description	1	Total amount invoiced grouped by period.
100	2	description	1	Detailed balance ageing report. Shows the age of outstanding customer balances.
100	3	description	1	Number of users subscribed to a specific product.
100	4	description	1	Total payment amount received grouped by period.
100	5	description	1	Number of customers created within a period.
100	6	description	1	Total revenue (sum of received payments) per customer.
100	7	description	1	Simple accounts receivable report showing current account balances.
100	8	description	1	General ledger details of all invoiced charges for the given day.
100	9	description	1	General ledger summary of all invoiced charges for the given day, grouped by item type.
100	11	description	1	Total invoiced per customer grouped by product category.
100	12	description	1	Total invoiced per customer over years grouped by year.
104	1	description	1	Invoices
104	2	description	1	Orders
104	3	description	1	Payments
104	4	description	1	Users
50	25	description	1	Use overdue penalties (interest).
50	27	description	1	Use order anticipation.
50	28	description	1	Paypal account.
50	29	description	1	Paypal button URL.
50	30	description	1	URL for HTTP ageing callback.
50	31	description	1	Use continuous invoice dates.
50	32	description	1	Attach PDF invoice to email notification.
50	33	description	1	Force one order per invoice.
50	35	description	1	Add order Id to invoice lines.
50	36	description	1	Allow customers to edit own contact information.
114	12	errorMessage	1	ABA Routing or Bank Account Number can only be digits
50	38	description	1	Link ageing to customer subscriber status.
50	39	description	1	Lock-out user after failed login attempts.
50	40	description	1	Expire user passwords after days.
50	41	description	1	Use main-subscription orders.
50	42	description	1	Use pro-rating.
50	43	description	1	Use payment blacklist.
50	44	description	1	Allow negative payments.
50	45	description	1	Delay negative invoice payments.
50	46	description	1	Allow invoice without orders.
50	49	description	1	Automatic customer recharge threshold.
50	50	description	1	Invoice decimal rounding.
50	4	instruction	1	Grace period in days before ageing a customer with an overdue invoice.
114	18	errorMessage	1	Email Validation Error
50	13	instruction	1	Set to '1' to e-mail invoices as the billing company. '0' to deliver invoices as jBilling.
50	14	instruction	1	Set to '1' to show notes in invoices, '0' to disable.
50	15	instruction	1	Days before the orders 'active until' date to send the 1st notification. Leave blank to disable.
50	16	instruction	1	Days before the orders 'active until' date to send the 2nd notification. Leave blank to disable.
50	17	instruction	1	Days before the orders 'active until' date to send the 3rd notification. Leave blank to disable.
50	18	instruction	1	Prefix value for generated invoice public numbers.
50	19	instruction	1	The current value for generated invoice public numbers. New invoices will be assigned a public number by incrementing this value.
50	20	instruction	1	Set to '1' to allow invoices to be deleted, '0' to disable.
50	21	instruction	1	Set to '1' to allow invoice reminder notifications, '0' to disable.
50	24	instruction	1	Set to '1' to enable, '0' to disable.
50	25	instruction	1	Set to '1' to enable the billing process to calculate interest on overdue payments, '0' to disable. Calculation of interest is handled by the selected penalty plug-in.
59	93	description	1	Show payments and refunds menu
50	27	instruction	1	Set to '1' to use the 'OrderFilterAnticipateTask' to invoice a number of months in advance, '0' to disable. Plug-in must be configured separately.
50	28	instruction	1	PayPal account name.
50	29	instruction	1	A URL where the graphic of the PayPal button resides. The button is displayed to customers when they are making a payment. The default is usually the best option, except when another language is needed.
50	30	instruction	1	URL for the HTTP Callback to invoke when the ageing process changes a status of a user.
114	13	errorMessage	1	Expiry date should be in format MM/yyyy
50	32	instruction	1	Set to '1' to attach a PDF version of the invoice to all invoice notification e-mails. '0' to disable.
50	33	instruction	1	Set to '1' to show the 'include in separate invoice' flag on an order. '0' to disable.
50	35	instruction	1	Set to '1' to include the ID of the order in the description text of the resulting invoice line. '0' to disable. This can help to easily track which exact orders is responsible for a line in an invoice, considering that many orders can be included in a single invoice.
50	36	instruction	1	Set to '1' to allow customers to edit their own contact information. '0' to disable.
114	13	errorMessage	3	Auslaufsdatum sollte im Format MM/jjjj sein
50	38	instruction	1	Set to '1' to change the subscription status of a user when the user ages. '0' to disable.
50	40	instruction	1	If greater than zero, it represents the number of days that a password is valid. After those days, the password is expired and the user is forced to change it.
50	42	instruction	1	Set to '1' to allow the use of pro-rating to invoice fractions of a period. Shows the 'cycle' attribute of an order. Note that you need to configure the corresponding plug-ins for this feature to be fully functional.
50	43	instruction	1	If the payment blacklist feature is used, this is set to the id of the configuration of the PaymentFilterTask plug-in. See the Blacklist section of the documentation.
50	44	instruction	1	Set to '1' to allow negative payments. '0' to disable
23	14	description	4	Prix du produit
50	45	instruction	1	Set to '1' to delay payment of negative invoice amounts, causing the balance to be carried over to the next invoice. Invoices that have had negative balances from other invoices transferred to them are allowed to immediately make a negative payment (credit) if needed. '0' to disable. Preference 44 & 46 are usually also enabled.
50	46	instruction	1	Set to '1' to allow invoices with negative balances to generate a new invoice that isn't composed of any orders so that their balances will always get carried over to a new invoice for the credit to take place. '0' to disable. Preference 44 & 45 are usually also enabled.
50	49	instruction	1	The threshold value for automatic payments. Pre-paid users with an automatic recharge value set will generate an automatic payment whenever the account balance falls below this threshold. Note that you need to configure the AutoRechargeTask plug-in for this feature to be fully functional.
50	50	instruction	1	The number of decimal places to be shown on the invoice. Defaults to 2.
90	1	description	1	Paid
90	2	description	1	Unpaid
90	3	description	1	Carried
59	10	description	1	Create customer
59	11	description	1	Edit customer
59	12	description	1	Delete customer
59	13	description	1	Inspect customer
59	14	description	1	Blacklist customer
59	15	description	1	View customer details
59	16	description	1	Download customer CSV
59	17	description	1	View all customers
59	18	description	1	View customer sub-accounts
59	20	description	1	Create order
59	21	description	1	Edit order
59	22	description	1	Delete order
59	23	description	1	Generate invoice for order
59	24	description	1	View order details
59	25	description	1	Download order CSV
59	26	description	1	Edit line price
59	27	description	1	Edit line description
59	28	description	1	View all customers
59	29	description	1	View customer sub-accounts
59	30	description	1	Create payment
59	31	description	1	Edit payment
59	32	description	1	Delete payment
59	33	description	1	Link payment to invoice
59	34	description	1	View payment details
59	35	description	1	Download payment CSV
59	36	description	1	View all customers
59	37	description	1	View customer sub-accounts
59	40	description	1	Create product
59	41	description	1	Edit product
59	42	description	1	Delete product
59	43	description	1	View product details
59	44	description	1	Download Product CSV
59	50	description	1	Create product category
59	51	description	1	Edit product category
59	52	description	1	Delete product category
59	70	description	1	Delete invoice
59	71	description	1	Send invoice notification
59	72	description	1	View invoice details
59	73	description	1	Download invoice CSV
59	74	description	1	View all customers
59	75	description	1	View customer sub-accounts
59	80	description	1	Approve / Disapprove review
59	90	description	1	Show customer menu
59	91	description	1	Show invoices menu
59	92	description	1	Show order menu
50	39	instruction	1	The number of retries to allow before locking the user account. A locked user account will be locked for the amount of minutes specified in Preference 68. To enable this locking feature, setting Preference 68 to a non-zero value is a must.
114	13	errorMessage	4	La date d'expiration doit être au format mm/aaaa
114	14	errorMessage	1	Payment card number is not valid
114	14	errorMessage	3	Bezahlungskartennummer ist nicht mehr gƒltig
114	14	errorMessage	4	Le numéro de carte de paiement est invalide
59	94	description	1	Show billing menu
59	96	description	1	Show reports menu
59	97	description	1	Show products menu
59	99	description	1	Show configuration menu
114	13	errorMessage	5	समाप्ति की तारीख प्रारूप माह / वर्ष में होना चाहिए
59	110	description	1	Switch to sub-account
59	111	description	1	Switch to any user
59	120	description	1	Web Service API access
100	10	description	4	Historique des tarifs du plan pour tous les produits et les dates de début du plan.
100	11	description	3	Gesamtrechnungen pro Kunde nach Produktkategorien gruppiert.
100	11	description	4	Totaux facturés par client regroupés par catégorie de produit.
100	12	description	3	Gesamtrechnungen pro Kunde über die Jahre, in Jahre gruppiert.
100	12	description	4	Total facturé par client au fil des ans avec regroupement par année.
100	13	description	4	Relevé de l'activité de l'utilisateur pendant un nombre de jours spécifié
100	1	description	3	Gesamtsumme berechnet, in Zeiträume gruppiert.
100	1	description	4	Montant total facturé regroupé par période
100	2	description	3	Detaillierter Balance Datierungsbericht. Zeigt die Datierung der hervorragenden Kundenguthaben.
100	2	description	4	Rapport détaillé sur l'avancement des phases du solde. Affiche la phase d'avancement des soldes débiteurs de clients.
100	3	description	3	Anzahl der Benutzer die ein spezifisches Produkt abonniert haben
100	3	description	4	Nombre d'utilisateurs abonnés à un produit spécifique.
100	4	description	3	Gesamtbezahlungen gruppiert bei Zeiträumen.
100	4	description	4	Montant total des paiements reçus regroupés par période
100	5	description	3	Anzahl der Kunden die in diesem Zeitraum erstellt wurden Number
100	5	description	4	Nombre de clients créés au sein d'une période.
100	6	description	3	Gesamteinnahmen (Summe der erhaltenen Bezahlunge) pro Kunde.
100	6	description	4	Total des revenus (somme des paiements reçus) par client.
100	7	description	3	Einfacher Forderungesbericht der Leistungsbilanzen anzeigt.
100	7	description	4	Simple rapport sur les comptes clients montrant les soldes actuels des comptes.
100	8	description	3	Hauptbuch Details aller in Rechnung gestellten Gebühren für den angegebenen Tag.
100	8	description	4	Détails du grand compte de tous les frais facturés pour le jour donné.
100	9	description	3	Hauptbuch Zusammenfassung aller in Rechnung gestellten Gebühren für den bestimmten Tag, in Elementtypen gruppiert.
100	9	description	4	Synthèse du grand compte de tous les frais facturés pour le jour donné, groupés par type d'article.
101	1	description	3	Rechnungsberichte
101	1	description	4	Rapports relatifs aux factures
101	2	description	3	Bestellungsberichte
101	2	description	4	Rapports relatifs aux commandes
101	3	description	3	Zahlungsberichte
101	3	description	4	Rapports relatifs aux paiements
101	4	description	3	Kundenberichte
101	4	description	4	Rapports relatifs aux clients
101	5	description	4	Rapports sur les plans
104	1	description	3	Rechnungen
104	1	description	4	Factures.
104	2	description	3	Bestellungen
104	2	description	4	Commandes.
104	3	description	3	Bezahlungen
104	3	description	4	Paiements.
104	4	description	3	Benutzer
104	4	description	4	Utilisateurs.
104	5	description	4	Notifications personnalisées
114	10	errorMessage	3	Bezahlungskartennummer ist nicht mehr gƒltig
114	10	errorMessage	4	Le numéro de carte de paiement est invalide
114	11	errorMessage	3	Auslaufsdatum sollte im Format MM/jjjj sein
114	11	errorMessage	4	La date d'expiration doit être au format mm/aaaa
114	12	errorMessage	3	ABA Routing oder Bank Kontonummer kann nur Zahlen sein
114	12	errorMessage	4	Le numéro de routage ABA ou le numéro de compte bancaire ne peut contenir que des chiffres
114	20	errorMessage	4	Le numéro de carte de paiement est invalide
114	21	errorMessage	4	La date d'expiration doit être au format mm/aaaa
114	22	errorMessage	4	Le numéro de routage ABA ou le numéro de compte bancaire ne peut contenir que des chiffres
114	23	errorMessage	4	Le numéro de carte de paiement est invalide
114	24	errorMessage	4	La date d'expiration doit être au format mm/aaaa
114	25	errorMessage	4	Le numéro de routage ABA ou le numéro de compte bancaire ne peut contenir que des chiffres
114	26	errorMessage	4	Le numéro de carte de paiement est invalide
114	27	errorMessage	4	La date d'expiration doit être au format mm/aaaa
114	28	errorMessage	4	Le numéro de routage ABA ou le numéro de compte bancaire ne peut contenir que des chiffres
114	29	errorMessage	4	Le numéro de carte de paiement est invalide
114	30	errorMessage	4	La date d'expiration doit être au format mm/aaaa
114	31	errorMessage	4	Le numéro de routage ABA ou le numéro de compte bancaire ne peut contenir que des chiffres
114	32	errorMessage	4	Le numéro de carte de paiement est invalide
114	33	errorMessage	4	La date d'expiration doit être au format mm/aaaa
114	34	errorMessage	4	Le numéro de routage ABA ou le numéro de compte bancaire ne peut contenir que des chiffres
114	35	errorMessage	4	Le numéro de carte de paiement est invalide
114	36	errorMessage	4	La date d'expiration doit être au format mm/aaaa
24	25	title	3	Standard asynchrone Parameter 
59	100	description	1	Show agent menu
114	37	errorMessage	4	Le numéro de routage ABA ou le numéro de compte bancaire ne peut contenir que des chiffres
114	38	errorMessage	4	Le numéro de carte de paiement est invalide
114	39	errorMessage	4	La date d'expiration doit être au format mm/aaaa
114	40	errorMessage	4	Le numéro de routage ABA ou le numéro de compte bancaire ne peut contenir que des chiffres
114	41	errorMessage	4	Le numéro de carte de paiement est invalide
114	42	errorMessage	4	La date d'expiration doit être au format mm/aaaa
17	1	description	3	Einmal
17	1	description	4	Une fois
17	5	description	3	Alle Auftrège
17	5	description	4	Toutes les commandes
18	1	description	3	Artikel
18	1	description	4	Articles
18	2	description	3	Steuer
18	2	description	4	Taxe
18	3	description	3	Strafe
18	3	description	4	Pénalité
18	4	description	3	Rabatt
18	4	description	4	Réduction
18	5	description	4	Abonnement
18	5	description	3	Abonnement
19	1	description	3	vorausbezahlt
19	1	description	4	prépayée
19	2	description	3	danach bezahlt
19	2	description	4	post-payée
23	10	description	3	Alarmiert wen nein Zahlungs Gateway nicht funktioniert
23	10	description	4	Alertes quand une passerelle de paiement est en dysfonctionnement
23	11	description	3	Abonnement Status Manager
23	11	description	4	Gestionnaire de statut des abonnements
23	12	description	3	 Parameter fƒr Asynchron-Zahlungsabwicklung
23	12	description	4	Paramètres pour le traitement asynchrone des paiements
23	13	description	3	Ein Produkt zur Bestllung hinzufƒgen
23	13	description	4	Ajouter un produit à commander
23	14	description	3	Produktpreise
23	15	description	3	Vermittlungs Reader
23	15	description	4	Visionneuse de médiation
23	16	description	3	Vermittlungs Prozessor
23	16	description	4	Système de traitement de la médiation
23	17	description	3	generische interne Ereignisse ZuhÖrer
23	17	description	4	Observateur d'évènements internes génériques
23	18	description	3	externer Beschaffungsprozessor 
23	18	description	4	Système de traitement de l'approvisionnement externe
23	19	description	3	 Kauf Validierung gegen Prepaid-Guthaben / Kreditlimit
23	19	description	4	Validation de l'achat par rapport au solde prépayé/à la limite de crédit
23	1	description	3	Artikel Management und Auftragsposition Gesamtberechnung
23	1	description	4	Gestion des articles et calcul du total des lignes de commande
23	20	description	3	Abrechnungsprozess: Kundenauswahl
23	20	description	4	Processus de facturation : sélection du client
23	21	description	3	Vermittlungsfehler Steuerungsprogram
23	21	description	4	Gestionnaire des erreurs de médiation
23	22	description	3	Geplante Plug-ins
23	22	description	4	Plugins programmés
23	23	description	3	Regelgenarator
23	23	description	4	Générateurs de règles
23	24	description	3	Vergƒtung fƒr Kunden mit ƒberfèlligen Rechnungen
23	24	description	4	Avancement de phase pour les clients avec des factures en retard de paiement
23	25	description	4	Processus de calcul des commissions des agents
23	26	description	4	Échange de fichiers avec des sites distants, télécharger
23	2	description	3	Abrechnungsprozess: Bestellung Filter
23	2	description	4	Processus de facturation : filtres des commandes
23	3	description	3	Abrechnungsprozess: Rechnung Filter
23	3	description	4	Processus de facturation : filtres des factures
23	4	description	3	Rechnungsvorlage
23	4	description	4	Présentation des factures
23	5	description	3	Abrechnungsprozess:  Auftragskalkulation Zeitraum
23	5	description	4	Processus de facturation : calcul des périodes de commande
23	6	description	3	Zahlungs Gateway integration
23	6	description	4	Intégration d'une passerelle de paiement
23	7	description	3	Mitteilungen
23	7	description	4	Notifications
23	8	description	3	Zahlungsinstrument Auswahl
23	8	description	4	Sélection d'un instrument de paiement
23	9	description	3	Strafen fƒr ƒberfèllige Rechnungen
23	9	description	4	Pénalités pour les factures impayées
24	101	description	3	Die Event basierte benutzerdefinierten Mitteilungsaufgabe nimmt die benutzerdefinierte Benachrichtigung und führt die Benachrichtigung durch, wenn ein internes Ereignis eingetreten ist
24	101	description	4	La tâche Notification personnalisée basée sur les évènements prend le message de notification personnalisé et réalise la notification lorsque l'évènement interne survient
24	101	title	3	Event basierte Kundenmitteilungsaufgabe
24	101	title	4	Tâche Notification personnalisée basée sur les évènements
24	103	title	3	Einfacher Vermittlungsprozessor
24	103	title	4	Système de traitement de médiation simple
24	105	description	3	Dieser plugin fügt Steuerzeilen auf die Rechnung hinzu durch die Befragung der Suretax Engine.
24	105	description	4	Ce plugin ajoute des lignes Taxe aux factures en consultant le moteur Suretax.
24	105	title	3	Suretax Plugin
24	105	title	4	Plugin Suretax
24	107	description	3	
24	25	title	4	Paramètres asynchrones standards
24	9	title	4	Notification standard par e-mail
24	107	description	4	Ce plugin définira la valeur du solde et du total d'une facture négative à 0, et il créera un paiement 'créditeur' pour le montant restant.
24	107	title	3	Kredit auf negativer Rechnung
24	107	title	4	Crédit sur facture négative
24	108	description	4	Une tâche pour utiliser un plugin du type InternalEventsTask afin de vérifier si le solde prépayé des utilisateurs est inférieur à un niveau seuil et d'envoyer des notifications.
24	108	title	4	Tâche Notification du seuil du solde de l'utilisateur
24	109	description	4	Ce plugin fournit une cartographie entre le statut de l'utilisateur (étapes d'avancement des phases) et les notifications devant être envoyées pour chaque statut
24	109	title	4	Notifications personnalisées à l'utilisateur par étapes d'avancement des phases
24	10	description	3	Findet die Informationen einer Zahlungsmethode die dem Kunden zur Verfƒgung stehen, Prioritèt auf Kreditkarten. Mit anderen Worten, es wird die Kreditkarte eines Kunden oder die ACH Informationen in dieser Reihenfolge zurƒckgeben.
24	10	description	4	Trouve les informations sur une méthode de paiement disponible pour un utilisateur, priorité étant donné aux cartes bancaires. En d'autres termes, it will return the credit car of a customer or the ACH information in that order.
24	10	title	3	Standard Zahlungsinformationen
24	10	title	4	Informations relatives au paiement par défaut
24	110	description	4	Cette tâche supprimera les fichiers ultérieur à une certaine période.
24	110	title	4	Supprimer les anciens fichiers
24	111	description	4	Ce plugin mettra à jour AssetTransitions en cas de changement de statut d'un actif.
24	111	title	4	Met à jour les transactions des actifs
24	112	description	4	Ce plugin supprimera les propriétaires de l'actif au moment de l'expiration de la commande associée.
24	112	title	4	Supprimer les actifs des commandes TERMINÉES
24	113	description	4	Une tâche pour utiliser un plugin de type InternalEventsTask pour contrôler des changements relatifs à activeUntil sur une commande
24	113	title	4	Tâche d'annulation de la commande
24	117	description	4	Ce plugin créera le regroupement d'utilisation pour le client si le client s'abonne à un plan qui est rattaché à des regroupements d'utilisation.
24	117	title	4	Créer un regroupement d'utilisation pour le client
24	118	description	4	Ce plugin évaluera et mettra à jour les regroupements d'utilisation du client afin de définir les dates de fin du cycle conformément à la période de regroupement d'utilisation, et il réinitialisera les quantités conformément au paramètre de définition des regroupements d'utilisation.
24	118	title	4	Tâche d'évaluation et de mise à jour du regroupement d'utilisation du client
24	119	description	4	Ce plugin mettra à jour le regroupement d'utilisation du client si un des évènements suivants se produit : NewOrderEvent, NewQuantityEvent, OrderDeletedEvent.
24	119	title	4	Tâche de mise à jour du regroupement d'utilisation du client
24	11	description	3	Plug-in nur hilfreich fƒr Testing useful
24	11	description	4	Plugin uniquement utile à des fins de test
24	11	title	3	Testing plug-in fƒr Partner Auszahlungen
24	11	title	4	Test du plugin pour le paiement des partenaires
24	120	description	4	Ce plugin mettra à jour les regroupements d'utilisation du client comme expirés si le client se désabonne d'un plan.
24	120	title	4	Il traite un évènement de désabonnement d'un plan pour un client. Il met à jour les regroupements d'utilisation du client comme expirés.
24	121	description	4	Si un évènement de consommation de regroupement d'utilisation a lieu, ce plugin lancera une action définie sur le FUP pour la consommation du pourcentage donnée
24	121	title	4	Tâche de consommation du regroupement d'utilisation du client
24	122	description	4	Ajoute des commandes d'approvisionnement pour la ligne de commande.
24	122	title	4	Ajoute des commandes d'approvisionnement pour la ligne de commande.
24	123	description	4	Ajoute des commandes d'approvisionnement lorsque les actifs sont créés, mis à jour et ajouté à la ligne du client
24	123	title	4	Ajoute des commandes d'approvisionnement pour les actifs.
24	124	description	4	Ajouter une commande d'approvisionnement lorsque le paiement est effectué.
24	124	title	4	Ajoute une commande d'approvisionnement lorsque le paiement est effectué
24	125	description	4	Traite le changement de statut de la commande
24	125	title	4	Traite le changement de statut de la commande
24	126	description	4	Crée des commandes à chaque qu'une ligne de commande est remplie via un changement de commande.
24	126	title	4	Crée des commandes d'approvisionnement pour le changement de commande.
24	127	description	4	Cette tâche planifie le processus qui calcule les commissions des agents.
24	127	title	4	Calculer les commissions des agents
24	128	description	4	Cette tâche calcule les commissions des agents.
24	128	title	4	Tâche Commissions des agents basiques
24	129	description	4	Ce plugin créera des commissions sur des paiements lorsque des paiements sont associés et désassociés des factures.
24	129	title	4	Générer des commissions sur les paiements pour les agents.
24	12	description	3	Wird eine PDF Version der Rechnung generieren.
24	12	description	4	Génèrera une version PDF d'une facture.
24	12	title	3	PDF Rechnung Mitteilung
24	12	title	4	Notification de facture au format PDF
24	133	description	4	Il déclenche le téléchargement par rapport à un système tiers
24	133	title	4	Déclencher le téléchargement des fichiers
24	134	description	4	Une tâche pour utiliser un plugin du type InternalEventsTask afin de vérifier si le solde prépayé des utilisateurs est inférieur aux niveaux 1 ou 2 de la limitation de crédit et d'envoyer des notifications.
24	134	title	3	Benutzer Kreditlimit Mitteilungsaufgabe
24	134	title	4	Tâche Notification de la limitation de crédit de l'utilisateur
35	15	description	3	Kredit
24	135	description	4	Ce gestionnaire des erreurs de médiation enregistre automatiquement les CDR qui se sont soldés par un échec vers le tableau 'cdr_recycling' de HBase.
24	135	title	4	Gestionnaire des erreurs de médiation HBase
24	136	description	4	Ce plugin changera la statut de la commande au moment où le changement de la commande s'appliquer au changement de commande sélectionné.
24	136	title	4	Changer le statut de la commande au moment où le changement s'applique
24	137	description	4	Si un évènement de facturation de consommation de regroupement d'utilisation a lieu, ce plugin facturera des frais au client
24	137	title	4	Tâche Facturation de la consommation du regroupement d'utilisation
24	138	description	4	Il s'agit d'un plugin programmé qui prend l'utilisateur qui ne s'est pas connecté pendant un nombre de jours indiqué dans Préférence 55 et qui met à jour son statut en Inactif.
24	138	title	4	Plugin de gestion des comptes utilisateur inactifs
24	14	description	3	Kommt immer falsch zurƒck, das ist warum Jbilling nie eine Rechnung auf eine neue Rechnung ƒbertrègt.
24	14	description	4	Renvoie toujours une valeur fausse, ce qui que jBilling ne reporte jamais une facture sur une autre plus récente.
24	14	title	3	Keine åbertragung der Rechnung
24	14	title	4	Aucune facture à reporter
24	15	description	3	Wird eine neue Bestellung mit einem Strafeartikel erstellen. Der Artikel wird als Parameter der Aufgabe gemacht.
24	15	description	4	Créera une nouvelle commande avec un article Pénalité. l'article est considéré comme un paramètre de la tâche.
24	15	title	3	Standard Interessepflicht
24	15	title	4	Tâche relative aux intérêts par défaut
24	16	description	3	 Erstreckt BasicOrderFilterTask, modifiziert die Daten, um die Bestellung ein paar Monaten im Vorraus zutreffen zu lassen, bevor es den Standardfilter benutzen wƒrde.
24	16	description	4	Étend BasicOrderFilterTask, en modifiant les dates pour que la commande soit applicable pendant un nombre de mois dans le passé plus élevé que ce qu'elle aurait dû en utilisant le filtre par défaut.
64	115	description	3	Laos
24	16	title	3	Voraussichtlicher Bestellungsfilter
24	16	title	4	Filtre pour les commandes anticipées
24	17	description	3	 Erstreckt BasicOrderFilterTask, modifiziert die Daten, um die Bestellung ein paar Monaten im Vorraus zutreffen zu lassen, bevor es den Standardfilter benutzen wƒrde.
24	17	description	4	Étend BasicOrderPeriodTask, en modifiant les dates pour que la commande soit applicable pendant un nombre de mois dans le passé plus élevé que ce qu'elle aurait dû en utilisant la tâche par défaut.
24	17	title	3	Voraussichtliche Bestellungszeitrèume.
24	17	title	4	Anticiper les périodes de commande
24	19	description	3	 Erweitert den standard authorize.net Zahlungsprozessor, und sendet auch eine E-Mail an das Unternehmen nach der Verarbeitung der Bezahlung.
24	19	description	4	Élargit les capacités du système de traitement des paiements standard authorize.net pour qu'il puisse également envoyer un e-mail à la société après le traitement du paiement.
24	19	title	3	Email & Prozess authorize.net
24	19	title	4	E-mail et traitement authorize.net
24	1	description	3	Berechnet die Auftragssumme und die Summe fƒr jede Zeile, unter Berƒcksichtigung der Artikelpreise, der Menge und ob die Preise ein Prozentsatz sind oder nicht.
24	1	description	4	Calcule le total de la commande et la total pour chaque ligne, en prenant en compte les prix des articles, the quantity and if the prices are percentage or not.
24	1	title	3	Standard Auftragssumme
24	1	title	4	Totaux des commandes par défaut
24	20	description	3	Sendet eine E-Mail an die Rechnungsadministrator als Alarm, wenn ein Zahlungsportal ausfèllt.
24	20	description	4	Envoie un e-mail au gestionnaire de facturation pour l'avertir qu'une passerelle de paiement est en dysfonctionnement.
24	20	title	3	Zahlungs Gateway ausgefallen alarm
24	20	title	4	Alerte Passerelle en dysfonctionnement.
24	21	description	3	 Ein Test der Zahlungsprozessorimplementierung, um jBillings Funktionen testen zu kÖnnen, ohne einen echten Zahlungs- Gateway zu benutzen.
24	21	description	4	Mise en place d'un système de traitement des paiements de test pour permettre de tester les fonctions de jBillings sans utiliser une véritable passerelle de paiement.
24	21	title	3	Test Zahlungsprozessor
24	21	title	4	Traitement test des paiements
24	22	description	3	AEin Kunde kann einem bestimmten Zahlungs-Gateway zugeordnet werden. Es prƒft ein benutzerdefiniertes Kontaktfeld, um den Gateway zu identifizieren und delegiert dann die Zahlungsabwicklung zu einem anderen Plug-in.
24	22	description	4	Il permet à un client de se voir assigné une passerelle de paiement spécifique. Le champ Contact personnalisé est vérifié en vue d'identifier la passerelle, puis le traitement du paiement réel est traité par un autre plugin.
24	22	title	3	Router Zahlungsprozessor auf kundenspezifische Felder basiert
24	22	title	4	Système de traitement des paiements via un routeur basé sur les champs personnalisés
24	23	description	3	Es legt fest, wie ein Zahlungsereignis sich auf den Abo-Status eines Benutzers auswirkt, gemessen an dem gegenwèrtigen Status und einer Zustandsmaschine.
24	23	description	4	Détermine la manière dont un évènement lié à un paiement affecte le statut de l'abonnement d'un utilisateur, en prenant en compte son statut actuel et une machine d'état.
24	23	title	3	Standard Abonnement Status Manager
24	23	title	4	Gestionnaire de statut des abonnements par défaut
24	24	description	3	Integration mit dem ACH commerce Zahlungs Gateway.
24	24	description	4	Intégration avec la passerelle de paiement commercial ACH.
24	24	title	3	ACH Commerce Zahlungsprozessor
24	24	title	4	Système de traitement des paiements commerçants ACH
24	25	description	3	 Eine Dummy Aufgabe, die keine Parameter fƒr asynchrone Zahlungsabwicklung hinzufƒgt. Dies ist der Standard.
24	25	description	4	Une tâche factice qui n'ajoute aucun paramètre pour le traitement des paiements asynchrone. C'est le défaut.
35	15	description	4	Crédit
24	26	description	3	Dieser Plug-in fƒgt Parameter fƒr Asynchrone Zahlungsabwicklung hinzu, um eine Verarbeitungsnachricht bean pro Zahlungsprozessor zu haben. Es wird in Kombination mit den Router Zahlungsprozessor -PlugIns verwendet.
24	26	description	4	Ce plugin ajoute des paramètres pour le traitement des paiements asynchrone pour qu'il ait un ben de message de traitement par système de traitement des paiements. Il est utilisé en combinaison avec les plugins des systèmes de traitement des paiements via un routeur.
24	26	title	3	Router asynchrone Parameter
24	26	title	4	Paramètres asynchrones via un routeur
24	28	description	3	Es fƒgt Artikel zu einer Bestellung hinzu. Wenn der Artikel bereits in der Bestellung ist, aktualisiert es nur die Menge.
24	28	description	4	Il ajoute des articles à une commande. Si l'article est déjà dans la commande, il ne met à jour que la quantité.
24	28	title	3	Standard Artikel Manager
24	28	title	4	Gestionnaire d'articles standard
24	29	description	3	Dies ist ein regelbasierte Plug-in. Er wird das tun, was der Grundelementmanager tut (eigentlich genannt); aber dann wird er auch externe Regeln durchfƒhren. Diese externen Regeln haben die volle Kontrolle ƒber die Bestllung die neue Artikel bekommt.
24	29	description	4	Il s'agit d'un plugin basé sur des règles. Il fera ce que le gestionnaire d'articles basique fait (l'appeler en réalité), mais ensuite il exécutera également des règles externes. Ces règles externes ont un contrôle total sur le changement de la commande qui reçoit de nouveaux articles.
24	29	title	3	Regelartikel Manager
24	29	title	4	Gestionnaire de l'article Règles
24	2	description	3	Fƒgt eine zusètzliche Zeile zum Autrag hinzu mit einem Prozentsatz um die Mehrwertsteuer darzustellen.
24	2	description	4	Ajoute une ligne supplémentaire à la commentaire avec une majoration en pourcentage représentant la taxe sur la valeur ajoutée.
24	2	title	3	VAT
24	2	title	4	TVA
24	66	title	4	Recharge automatique.
24	67	description	3	Zahlungsanbiter für Integration mit dem Beanstream Zahlungs gateway
24	30	description	3	 Dies ist ein regelbasierter Plug-in. Er berechnet die Gesamtsumme fƒr eine Bestellung (in der Regel ist dies der Preis, multipliziert mit der Menge); so dass externe Regeln durchgefƒhrt werden kÖnnen.
24	30	description	4	Il s'agit d'un plug-in basé sur des règles. Il calcule le total pour une ligne de commande (généralement il s'agit du prix multiplié par la quantité), permettant ainsi l'exécution des règles externes.
24	30	title	3	Regel Zeile Gesamtsumme
24	30	title	4	Règles du total de la ligne
24	31	description	3	Dies ist ein regelbasierter Plug-in. Er gibt den Preis eines Artikels durch die Ausfƒhrung externer Vorschriften. Anschlieºend kÖnnen Sie Logik extern fƒr die Preise hinzufƒgen. Es ist auch mit dem Vermittlungsverfahren integriert, durch den Zugang zu der Vermittlungspreisdaten.
24	31	description	4	Il s'agit d'un plug-in basé sur des règles. Il donne un prix à un article en appliquant des règles externes. Vous pouvez ajouter une logique externe pour la tarification. Il est également intégré avec le processus de médiation en ayant accès aux données de tarification de la médiation.
24	31	title	3	Regelpreise
24	31	title	4	Règles de tarification
24	32	description	3	 Dies ist ein Reader fƒr das Vermittlungsverfahren. Er liest Datensètze aus einer Textdatei, deren Felder durch ein Zeichen (oder Zeichenfolge) getrennt sind.
24	32	description	4	Il s'agit d'une visionneuse pour le processus de médiation. Il lit les enregistrements provenant d'un fichier texte dont les champs sont séparés par un caractère (ou une chaîne de caractères).
24	32	title	3	Trenner Datei Reader
24	32	title	4	Visionneuse de fichier avec séparateur
24	33	description	3	Dies ist ein regelbasierter Plug-In (siehe Kapitel 7). Er nimmt eine Ereignisaufzeichnung aus dem Vermittlungsverfahren und fƒhrt externe Regeln durch, um den Datensatz in aussagekrèftige Abrechungsdaten zu ƒbersetzen. Dies ist der Kern des Vermittlungselements, siehe die ? Telecom Guide? Dokumentation fƒr weitere Informationen.
24	33	description	4	Il s'agit d'un plug-in basé sur des règles (voir Chapitre 7) Il effectue un enregistrement des évènements à partir du processus de médiation et il exécute des règles externes pour traduire l'enregistrement en données de facturation pertinentes. Il s'agit d'un élément essentiel du composant de la médiation, reportez-vous au 'Guide des télécoms' pour obtenir plus d'informations.
24	33	title	3	Regel Vermittlungsprozessor
24	33	title	4	Système de traitement des règles de médiation
24	34	description	3	 Dies ist ein Reader fƒr das Vermittlungsverfahren. Er liest Datensètze aus einer Textdatei, deren Felder fixierte Positionen haben, und der Datensatz hat eine feste Lènge.
24	34	description	4	Il s'agit d'une visionneuse pour le processus de médiation. Il lit les enregistrements provenant d'un fichier texte dont les champs ont des positions fixes, 'et l'enregistrement dispose d'une longueur fixe.
24	34	title	3	Festgelegte Lènge Dateireader
24	34	title	4	Lecteur de fichier avec longueur fixe
24	35	description	3	Das ist genau das gleiche wie die Standard-Zahlungsinformationen Aufgabe, der einzige Unterschied ist, dass es nicht validiert, wenn die Kreditkarte abgelaufen ist. Verwenden Sie dieses Plug-in nur, wenn Sie die Zahlung mit abgelaufene Kreditkarten einreichen mÖchten.
24	35	description	4	Il s'agit d'exactement la même chose que pour la tâche des informations relatives aux paiements, la seule différence est qu'il ne valide pas si la carte bancaire a expiré. Utilisez ce plugin uniqumenet si vous voulez envoyer des paiements avec des cartes bancaires expirées.
24	35	title	3	Zahlungsinformationen ohne Bestètigung
24	35	title	4	Informations relatives aux paiements sans validation
24	36	description	3	 Dieser Plug-in ist nur zu Testzwecken zu verwenden. Anstatt einer E-Mail (oder anderen wirklichen Mitteilungen); speichert es einfach den Text in einer Datei mit dem Namen emails_sent.txt.
24	36	description	4	Ce plugin est uniquement utilisé à des fins de test. Au lieu d'envoyer un e-mail (ou une autre notification réelle), il stocke simplement le texte à envoyer dans un fichier appelé emails_sent.txt.
24	36	title	3	Mitteilung fƒr Testing
24	36	title	4	Tâche de notification à des fins de test
24	37	description	3	 Dieses Plugin berƒcksichtigt den Feldkreislauf der Bestellungen um zu die Teilbestellzeiten zu berechnen.
24	37	description	4	Ce plugin prend en considération le champ Débuts de cycles des commandes pour calculer des périodes de commande fractionnées.
24	37	title	3	 Bestellfristen Rechner mit Pro-Bewertung.
24	37	title	4	Calculateur de périodes de commande avec paiement au prorata.
24	38	description	3	 Bei der Erstellung einer Rechnung aus einer Bestellung, wird dieses Plug-in jeder Bruchteil eines Zeitraums berechnen, mit einem Tages als kleinste abrechenbare Einheit.
24	38	description	4	Lors de la création d'une facture à partir d'une commande, ce plugin payera au prorata toute fraction d'une période en prenant un jour comme unité facturable la plus petite.
24	38	title	3	 Rechnungs Zusammensetzungsaufgabe mit pro-Rating (Tag-Fraktion)
24	38	title	4	Tâche de composition des factures avec paiement au prorata (jour sous forme de fraction)
24	39	description	3	Integration mit dem Intraanuity Zahlungs Gateway.
24	39	description	4	Intégration avec la passerelle de paiement Intraanuity.
24	39	title	3	Zahlungsprozess fƒr den Intraanuity Zahlungs Gateway
24	39	title	4	Processus de paiement pour la passerelle de paiement Intraanuity
24	3	description	3	Eine sehr einfache Implementierung, die das Fèlligkeitsdatum der Rechnung festsetzt. Das Fèlligkeitsdatum wird berechnet der Zeitraum auf das Rechnungsdatum hinzugefƒgt wird.
24	3	description	4	Une intégration très simple qui permet de définir la date d'échéance de la facture. La date d'échéance est calculée en ajoutant simplement la période de temps à la date facturée.
24	3	title	3	Rechnung Fèlligkeitsdatum
24	3	title	4	Date d'échéance de la facture
24	40	description	3	 Dieser Plug-in wird eine neue Bestllung mit einem negativen Preis erstellen, welche einen Kredit widerspiegelt, wenn eine Bestellung innerhalb eines bereits abgerechneten Zeitraums storniert wurde.
24	87	title	4	Avancement basique des phases
24	40	description	4	Ce plugin créera une nouvelle commande avec un prix négatif afin de refléter un crédit lorsqu'une commande est annulée au cours d'une période qui a déjà été facturée.
24	40	title	3	Automatischer Storierungskredit.
24	40	title	4	Crédit automatique pour annulation.
24	42	description	3	 Verwendet fƒr die Sperrung der Zahlungen vom Erreichen realer Zahlungsdienste. In der Regel als erster Zahlungsprozessor in der Verarbeitungskette konfiguriert.
24	42	description	4	Il est utilisé pour empêcher que les paiements n'atteignent de véritables systèmes de traitement des paiements. Il est généralement configuré comme premier système de traitement des paiements dans la chaîne de traitement.
24	42	title	3	Sperrliste Filter Zahlungsprozessor.
24	42	title	4	Filtre Liste noire pour systèmes de traitement des paiements.
24	43	description	3	Setzt Benutzer und die dazugehÖrigen Informationen (zB Kreditkartennummer, Telefonnummer, etc.) auf die schwarze Liste, wenn ihr Status ausgesetzt oder hÖher ist.
24	43	description	4	Entraîne l'inscription sur la liste noire des clients et de leurs informations associées (ex : numéro de carte bancaire, numéro de téléphone, etc.) si leur statut devient Suspendu ou supérieu. 
24	43	title	3	 Benutzer sperren, wenn deren Status wird ausgesetzt oder höher wird.
24	43	title	4	Place l'utilisateur sur une liste noire lorsque son statut devient suspendu ou supérieur.
24	44	description	3	Dies ist ein Reader für das Vermittlungsverfahren. Er liest Datensètze aus einer JDBC-Datenbankquelle.
24	44	description	4	Il s'agit d'une visionneuse pour le processus de médiation. Il lit les enregistrements à partir d'une source de bases de données JDBC.
24	44	title	3	JDBC Vermittlungs Reader.
24	44	title	4	Visionneuse de médiation JDBC
24	45	description	3	Dies ist ein Reader für das Vermittlungssverfahren. Es ist eine Erweiterung des JDBC-Reader, der eine einfache Konfiguration einer MySQL-Datenbankquelle erlaubt.
24	45	description	4	Il s'agit d'une visionneuse pour le processus de médiation. C'est une extension du lecteur JDBC, permettant une configuration aisée d'une source de base de données MySQL.
24	45	title	4	Visionneuse de médiation MySQL.
24	46	description	3	Reagiert auf Events die mit Bestellungen verbunden sind. Lässt Regeln laufen, um Befehle zu erzeugen, die über JMS-Nachrichten an das externe Bereitstellungsmodul geschickt werden.
24	46	description	4	Il réagit aux évènements associées aux commandes. Il exécute des règles pour générer des commandes à envoyer via des messages JMS vers un module d'approvisionnement externe.
24	46	title	3	 Bereitstellungsbefehle Regelaufgabe
24	46	title	4	Tâche des règles des commandes d'approvisionnement.
24	47	description	3	Dieses Plug-in wird nur zu Testzwecken verwendet. Es ist eine Test externe Bereitstellungsaufgabe zum Testen der Bereitstellungsmodule.
24	47	description	4	Ce plugin est uniquement utilisé à des fins de test. Il s'agit d'une tâche de test d'approvisionnement externe afin de tester les modules d'approvisionnement.
24	47	title	3	Externe Bereitstellungsaufgabe testen.
24	47	title	4	Tâche de test d'approvisionnement externe.
24	48	description	3	Ein externer Bereitstellungs Plug-in für die Kommunikation mit dem Ericsson Kundenverwaltungs Interface (CAI).
24	48	description	4	Un plugin d'approvisionnement externe pour communiquer avec l'interface d'administration des clients d'Erisson (CAI).
24	48	title	3	CAI externe Bereitstellungsaufgabe
24	48	title	4	Tâche d'approvisionnement externe pour CAI.
24	49	description	3	Delegiert die eigentliche Zahlungsabwicklung zu einem anderen Plug-in auf der Basis der Währung der Zahlung.
24	49	description	4	Il délègue le traitement réel des paiements à un autre plugin selon la devise du paiement.
24	49	title	3	Währungs Router Zahlungsanbieter
24	49	title	4	Système de traitement des paiements avec routeur pour les devises
24	4	description	3	Diese Aufgabe wird alle Linien auf den Bestellungen und Rechnungen auf die neuen Rechnung kopieren, unter Berƒcksichtigung der Zeitrèume fƒr jeden beteiligten Auftrag, nicht aber die Fraktionen von Zeitrèumen. Die Zeilen, die Steuern sind werden nicht kopiert. Die Menge und Gesamtbetrag jeder Zeile wird durch die Menge der Zeitrèume multipliziert werden.
24	4	description	4	Cette tâche copiera toutes les lignes sur les commandes et les factures vers la nouvelle facture, en prenant en compte les périodes concernées pour chaque commande, but not the fractions of periods. It will not copy the lines that are taxes. The quantity and total of each line will be multiplied by the amount of periods.
24	4	title	3	Standard Rechnungszusammensetzung.
24	4	title	4	Composition de la facture par défaut.
24	50	description	3	Ein externer Bereitstellungs plug-in für die Kommunikation mit dem TeliaSonera MMSC.
24	50	description	4	Un plugin d'approvisionnement externe pour communiquer avec le MMSC de TeliaSonera.
24	50	title	3	MMSC externe Bereitstellungsaufgabe
24	50	title	4	Tâche d'approvisionnement externe pour MMSC.
24	51	description	3	Dieser Filter wird nur Rechnungen mit einem positiven Saldo auf die nächste Rechnung übertragen.
24	51	description	4	Ce plug-in filtrera uniquement les factures avec un solde positif devant être reportées sur la facture suivante.
24	51	title	3	Filtert negative Rechnungen für Übertragungen.
24	51	title	4	Filtre les factures négative pour les reports.
24	52	description	3	Es wird eine Datei mit einer Zeile pro Rechnung generieren.
24	52	description	4	Il génèrera un fichier avec une ligne par facture générée.
24	52	title	3	Datei-Rechnungs Exporteur.
24	52	title	4	Exportateur de fichier de factures.
24	53	description	3	Es wird ein Bündel von Vorschriften nennen, wenn ein internes Ereignis eintritt.
24	53	description	4	Il appellera un ensemble de règles lorsqu'un évènement interne se produira.
24	53	title	3	Regel Caller für ein Ereignis.
24	53	title	4	Contrôleur de règles pour un évènement.
60	4	title	4	Agent
24	54	description	3	Es wird das dynamische Gleichgewicht eines Kunden (Prepaid-oder Kreditlimit) aktualisieren, wenn Ereignisse mit Auswirkungen auf das Gleichgewicht auftreten.
24	54	description	4	Il mettra à jour le solde dynamique d'un client (prépayé ou limite de crédit) si des évènements affectant le solde se produisent.
24	54	title	3	Dynamischer Balance Manager
24	54	title	4	Gestionnaire de solde dynamique
24	55	description	3	Für die Echtzeit-Vermittlung benutzt, dieser Plug-in wird einen Anruf auf der Grundlage des aktuellen dynamischen Gleichgewichts eines Kunden validieren.
24	55	description	4	Utilisé pour la médiation en temps réel, ce plugin validera un appel selon le solde dynamique actuel d'un client.
24	55	title	3	Balanceprüfer auf der Grundlage der Kundenbilanz.
24	55	title	4	Validateur de solde basé sur le solde du client.
24	56	description	3	Für die Echtzeit-Vermittlung benutzt, dieses Plug-in wird einen Anruf auf der Grundlage eines Bündels oder Regeln validieren
24	56	description	4	Utilisé pour la médiation en temps réel, ce plugin validera un appel selon un lot ou des règles.
24	56	title	3	Balanceprüfer basierend auf Regeln
24	56	title	4	Validateur de solde basé sur des règles.
24	57	description	3	Integration mit dem Gateway-Zahlungs Zahlungsanbieter.
24	57	description	4	Intégration avec le système de traitement des paiements Payments Gateway.
24	57	title	3	Zahlungsanbiert für Zahlung Gateway.
24	57	title	4	Système de traitement de paiements Payments Gateway.
24	58	description	3	Speichert die Kreditkarteninformationen in dem Zahlungs-Gateway, anstatt der Jbilling DB.
24	58	description	4	Il enregistre les informations relatives à la carte bancaire sur la passerelle de paiement, au lieu de la base de données jBilling.
24	58	title	3	Kreditkarten werden extern gespeichert.
24	58	title	4	Les cartes bancaires sont stockées en externe.
24	59	description	3	Dies ist ein regelbasierter Plug-in kompatibel mit dem Vermittlungsmodul von Jbilling 2.2.x. Er wird das tun, was die Grundelementmanager tut (eigentlich genannt); aber dann wird er auch externen Regeln ausführen. Diese externen Regeln haben die volle Kontrolle über die Veränderung der Bestellung welche neue Artikel bekommt.
24	59	description	4	Il s'agit d'un plugin basé sur des règles avec le module de médiation de jBilling 2.2.x., Il fera ce que le gestionnaire d'articles basique fait (l'appeler en réalité), mais ensuite il exécutera également des règles externes. Ces règles externes ont un contrôle total sur le changement de la commande qui reçoit de nouveaux articles.
24	59	title	3	Artikelregel Manager 2
24	59	title	4	Gestionnaire de l'article Règles 2
24	5	description	3	 Entscheidet, ob eine Bestellung in einer Rechnung fƒr einen bestimmten Abrechnungsprozess einbezogen werden soll. Dies geschieht, indem man die Abrechnungszeitspanne, den Zeitraum, die aktive Zeit seit/bis, usw berechnet
24	5	description	4	Décide si une commande doit être incluse dans une facture pour un processus de facturation donné.  Cela s'effectue en prenant la période déterminée pour le processus de facturation, la période de commande, the active since/until, etc.
24	5	title	3	Standard Bestellungs Filter
24	5	title	4	Filtre standard pour les commandes
24	60	description	3	Dies ist ein regelbasierter Plug-in, kompatibel mit dem Vermittlungsverfahren von Jbilling 2.2.x und besser. Er berechnet die Gesamtleitung für einen Auftrag (in der Regel ist dies der Preis, multipliziert mit der Menge); so dass externen Regeln durchgeführt werden können.
24	60	description	4	Il s'agit d'un plugin basé sur des règles, compatible avec les versions du processus de médiation de jBilling 2.2.x et supérieures. Il calcule le total pour une ligne de commande (généralement il s'agit du prix multiplié par la quantité), permettant ainsi l'exécution des règles externes.
24	60	title	3	Regeln Gesamtzeilen- 2
24	60	title	4	Règles du total de la ligne - 2
24	61	description	3	Dies ist ein regelbasierter Plug-in kompatibel mit dem Vermittlungsmodul von Jbilling 2.2.x. Er gibt einen Preis zu einem Artikel an, durch Ausführen externer Vorschriften. Anschließend können Sie Logik extern für die Preise hinzufügen. Er ist auch mit dem Vermittlungsverfahren durch den Zugang zu der Vermittlungs Preisdaten integriert.
24	78	description	3	Erzeugt Regeln dynamisch, basiert auf auf eine Velocity Vorlage.
24	61	description	4	Il s'agit d'un plugin basé sur des règles avec le module de médiation de jBilling 2.2.x., Il donne un prix à un article en appliquant des règles externes. Vous pouvez ajouter une logique externe pour la tarification. Il est également intégré avec le processus de médiation en ayant accès aux données de tarification de la médiation.
24	61	title	3	Regel Preisliste 2
24	61	title	4	Règles de tarification 2
24	63	description	3	Eine falscher Plug-in, um Zahlungen, die extern gespeichert werden würden zu testen.
24	63	description	4	Un faux plugin pour tester les paiements qui seraient stockées en externe.
24	63	title	3	Test Zahlungprozessor für externe Speicher.
24	63	title	4	Système de traitement des paiements test pour stockage externe.
24	64	description	3	Zahlungsprozessor-Plug-in, mit RBS WorldPay integriert
24	64	description	4	Plugin de système de traitement des paiements à intégrer avec RBS WorldPay.
24	64	title	3	WorldPay Integration
24	64	title	4	Intégration de WorldPay.
24	65	description	3	 Zahlungsprozessor-Plug-in, mit RBS WorldPay integriert. Er speichert die Kreditkarteninformationen (Nummer, usw.) in dem Gateway.
24	65	description	4	Plugin de système de traitement des paiements à intégrer avec RBS WorldPay. Il stocke les informations relatives à la carte bancaire (numéro, etc) sur la passerelle.
24	65	title	3	WorldPay Integration mit externem Speicher
24	65	title	4	Intégration de WorldPay avec stockage externe.
24	66	description	3	Überwacht das Gleichgewicht von einem Kunden und beim Erreichen eines Limits, fordert eine Echtzeit-Zahlung an
24	66	description	4	Il contrôle le solde d'un client et au moment d'atteindre une limite, il demande un paiement en temps réel
24	66	title	3	Auto Aufladen
24	67	description	4	Système de traitement des paiements pour une intégration avec la passerelle de paiement Beanstream.
24	67	title	3	Beanstream Gateway Integration
24	67	title	4	Intégration d'une passerelle Beanstream
24	68	description	3	Zahlunganbieter für Integration mit dem Sage Zahlungs Gateway
24	68	description	4	Système de traitement des paiements pour une intégration avec la passerelle de paiement Sage.
24	68	title	3	Sage Zahlungs gateway Integration
24	68	title	4	Intégration d'une passerelle de paiement Sage
24	69	description	3	Wird aufgerufen, wenn die Abrechnung läuft um auszuwählen welche Benutzer bewertet werden. Diese grundlegende Implementierung zeigt einfach jedem Benutzer an der nicht im gesperrten (oder schlimmer) Status ist
24	69	description	4	Appelé lorsque le processus de facturation s'exécute pour sélectionner quels utilisateurs évaluer. Cet exercice de base renvoie simplement le fait que tous les utilisateurs n'ont pas un statut Suspendu (ou pire)
24	69	title	3	Standard Abrechnungs Benutzer Filter 
24	69	title	4	Filtre utilisateurs pour le processus de facturation standard
24	6	description	3	 Gibt immer True zurƒck, was bedeutet, dass die ƒberfèllige Rechnung auf eine neue Rechnung ƒbertragen wird.
24	6	description	4	Renvoie toujours une valeur vraie, ce qui signifie que la facture impayée sera reportée sur une nouvelle facture.
24	6	title	3	Standard Rechnungs Filter
24	6	title	4	Filtre pour les factures standard
24	70	description	3	Wird aufgerufen, wenn die Abrechnung läuft, um auswählen, welche Benutzer zu bewerten. Dies zeigt nur Benutzer mit Bestellungen an, die ein nächstes Abrechnungsdatum früher als den Abrechnungsprozess haben.
24	70	description	4	Appelé lorsque le processus de facturation s'exécute pour sélectionner quels utilisateurs évaluer. Il ne renvoie que les utilisateurs avec des commandes dont la date de la prochaine facture est antérieure au processus de facturation.
24	70	title	3	Auswahl Abrechnungs Benutzerfilter
24	70	title	4	Filtre utilisateurs pour le processus de facturation sélectif
24	71	description	3	Ereignisdatensätze mit Fehlern werden in einer Datei gespeichert
24	71	description	4	Les enregistrements avec des erreurs sont enregistrés dans un fichier
24	71	title	3	Vermittlungs Datei Fehler Steuerungsprogramm
24	71	title	4	Gestionnaire des erreurs du fichier de médiation
24	73	description	3	 Ereignis-Datensätzen mit Fehler werden in einer Datenbanktabelle gespeichert
24	73	description	4	Les enregistrements avec des erreurs sont enregistrés dans la table d'une base de données
24	73	title	3	Vermittlungsdatensatz basiertes Fehler Steuerungsprogramm
24	73	title	4	Gestionnaire des erreurs de la base de données de médiation
24	75	description	3	Sendet Zahlungen an PayPal als Zahlungsgateway und speichert auch Kreditkarteninformationen in PayPal
24	75	description	4	Il envoie des paiements à PayPal en tant que passerelle de paiement et il stocke également les informations relatives à la carte bancaire dans PayPal
24	75	title	3	Paypal Integration mit externem Speicher
24	75	title	4	Intégration de PayPal avec stockage externe.
24	76	description	3	Sendet Zahlungen an authorize.net als Zahlungs-Gateway und speichert auch Kreditkarteninformationen in authorize.net
24	76	description	4	Il envoie des paiements à authorize.net en tant que passerelle de paiement et il stocke également les informations relatives à la carte bancaire dans authorize.net
24	76	title	3	Authorize.net Integration mit externem Speicher
24	76	title	4	Intégration de authorize.net avec stockage externe.
24	77	description	3	Delegiert die eigentliche Zahlungsabwicklung zu einem anderen Plug-in auf der Grundlage der Zahlungsmethode der Zahlung.
24	77	description	4	Il délègue le traitement réel des paiements à un autre plugin selon la méthode de paiement.
24	77	title	3	Zahlungsmethode Router Zahlungsprozessor
24	77	title	4	Système de traitement des paiements avec routage selon la méthode de paiement
24	78	description	4	Il génère des règles de manière dynamique selon un modèle Velocity
24	78	title	3	Dynamischer Regelgenerator
24	78	title	4	Générateur de règles dynamiques
24	79	description	3	Dies ist ein Plugin, das sich mit Preisberechnungbefasst, auf die it von den implemenations der verschiedenen Preismodelle basiert.
24	79	description	4	Il s'agit d'un plugin qui gère le calcul des tarifs selon l'exécution de différents modèles de prix.
24	79	title	3	Preismodell Preisaufgabe
24	79	title	4	Tâche de tarification selon des modèles de prix.
24	7	description	3	Berechnet den Beginn und den Endzeitraum in einer Rechnung. Dies geschieht, indem man die Abrechnungszeitspanne, den Zeitraum, die aktiven Zeit seit/bis, usw berechnet.
24	7	description	4	Calcule le début et la fin de la période à inclure dans une facture. Cela s'effectue en prenant la période déterminée pour le processus de facturation, la période de commande, the active since/until, etc.
24	7	title	3	Standard Bestellungszeitraum
24	7	title	4	Périodes de commande par défaut
24	80	description	3	Eine geplante Aufgabe, um den Abrechnungsablauf durchzuführen.
24	80	description	4	Une tâche programmée pour exécuter le processus de facturation.
24	80	title	3	Abrechnungsaufgabe
24	80	title	4	Tâche Processus de facturation
24	81	description	3	Eine geplante Aufgabe, um den Vermittlungsablauf auszuführen.
24	81	description	4	Une tâche programmée pour exécuter le processus de médiation.
24	81	title	3	Vermittlungsprozessaufgabe
24	81	title	4	Tâche Processus de médiation
24	87	description	3	 Datiert einen Benutzer auf der Grundlage der Anzahl der Tage, die das Konto überfällig ist.
24	87	description	4	Détermine la phase d'un utilisateur selon le nombre de jours pendant lequel le compte est débiteur.
24	87	title	3	Einfache Datierung
24	88	description	3	Eine geplante Aufgabe, um den Datierungsprozess auszuführen.
24	88	description	4	Une tâche programmée pour exécuter le processus d'avancement des phases.
24	88	title	3	Datierungprozessaufgabe
24	88	title	4	Tâche Processus d'avancement des phases
24	89	description	3	Datiert einen Benutzer auf der Grundlage der Anzahl von Werktagen (außer an Feiertagen), die das Konto überfällig ist.
24	89	description	4	Détermine la phase d'un utilisateur selon le nombre de jours ouvrés (hors week-end et jours fériés) pendant lequel le compte est débiteur.
24	89	title	3	Werktag Datierung
24	89	title	4	Avancement des phases en jours ouvrés
24	8	description	3	Integration mit dem  authorize.net Zahlungs Gateway.
24	8	description	4	Intégration avec la passerelle de paiement authorize.net.
24	8	title	3	Authorize.net Zahlungsprozessor
24	8	title	4	Système de traitement des paiements Authorize.net
24	90	description	3	Eine steckbare Aufgabe der Art von AbstractChargeTask um einen Steuer Artikel auf die Rechnung hinzuzüfugen, mit einer Einrichtung der Freistellung um einen Artikel freizugeben oder einen Kunden freizustellen.
24	90	description	4	Une tâche pour utiliser le plugin du type AbstractChargeTask pour appliquer un article fiscal à une facture avec une fonction permettant d'exempter un article ou un client.
24	90	title	3	Einfache Steuer Zusammensetzungsaufgabe
24	90	title	4	Tâche Composition fiscale simple
24	91	description	3	Eine steckbare Aufgabe der Art von AbstractChargeTask um einen Steuer Artikel auf die Rechnung hinzuzufügen, wenn der Ländercode des Partners übereinstimmt.
24	91	description	4	Une tâche pour utiliser un plugin AbstractChargeTask pour appliquer un article fiscal à la facture si le code pays du partenaire correspond.
24	91	title	3	Landsteuerrechnung Zusammensetzungsaufgabe 
24	91	title	4	Tâche Composition d'une facture de taxe nationale
24	92	description	3	Eine steckbare Aufgabe der Art von AbstractChargeTask um eine Strafe auf eine Rechnung hinzuzufügen, die ein Fälligkeitsdatum über einen konfigurierbaren Zeitraum hinweg hat.
24	92	description	4	Une tâche pour utiliser un plugin du type AbstractChargeTask pour appliquer une pénalité à une facture dont la date d'échéance est au-delà de la période configurable en termes de nombre de jours.
24	92	title	3	Zahlungsbedingungen Strafaufgabe
24	92	title	4	Tâche Pénalité relative aux Conditions de Paiement
24	96	description	3	Dies ist ein Abonnement Ereignis basiertes Plugin. Es nimmt Datensätze aus dem Vermittlungsverfahren auf und übersetzt sie in aussagekräftige Rechnungsdaten. Es konzentriert sich auf wiederkehrende Bestellungen. Wenn kein Bestellung verfügbar ist, erstellt es eine neue.
24	96	description	4	Plugin basé sur les évènements liés aux abonnements. Il effectue des enregistrements à partir du processus de médiation et il les traduit en données de facturation pertinentes. Il se centre sur des commandes récurrentes. Si aucune facture n'est disponible, il en créer une nouvelle.
24	96	title	3	Abonnement Ereignisprozessor
24	96	title	4	Système de traitement des évènements liés aux abonnements
24	97	description	3	Diese Aufgabe ist zum Anlegen eines % -Satzes oder einem festen Strafbetrag auf eine überfällige Rechnung verantwortlich. Diese Aufgabe ist aussagekräftig, weil es diese Aktion kurz vor dem Abrechnungsprozess der gesammelten Bestellungen ausführt.
24	97	description	4	Cette tâche est chargée d'appliquer une pénalité correspondant à un pourcentage ou à un montant fixe sur une facture impayée. Cette tâche est très efficace car elle effectue cette action juste avant que le processus de facturation ne collecte les commandes.
24	97	title	3	Strafaufgabe für überfällige Rechnung
24	97	title	4	Tâche Pénalité sur les impayés
24	9	description	3	Teil dem Benutzer etwas per Email mit. Text und HTML Emails sind unterstƒzt.
24	9	description	4	Notifie un utilisateur par l'envoi d'un e-mail. Les e-mails texte et HTML sont pris en charge
24	9	title	3	Standard Email Mitteilungen
35	1	description	4	Chèque
35	2	description	3	Visa
35	2	description	4	Visa
35	3	description	3	MasterCard
35	3	description	4	MasterCard
35	4	description	3	AMEX
35	4	description	4	AMEX
35	5	description	3	ACH
35	5	description	4	ACH
35	6	description	3	Entdeckung
35	6	description	4	Discover
35	7	description	3	Diners
35	7	description	4	Diners
35	8	description	3	PayPal
35	8	description	4	PayPal
4	10	description	3	Malaysischer Ringgit
4	10	description	4	Ringgit malaysien
4	11	description	3	Australischer Dollar
41	1	description	3	Erfoglreich
4	11	description	4	Dollar australien
41	1	description	4	Réussite
41	2	description	3	Fehlgeschlagen
41	2	description	4	Échec
41	3	description	3	Prozessor nicht verfƒgbar
41	3	description	4	Système de traitement indisponible
41	4	description	3	Eingetreten
41	4	description	4	Saisie
4	1	description	3	US-Dollar
4	1	description	4	Dollar américain
4	2	description	3	Kanadischer Dollar
4	2	description	4	Dollar canadien
4	3	description	3	Euro
4	3	description	4	Euro
4	4	description	3	Yen
4	4	description	4	Yen
4	5	description	3	Pfund Sterling
4	5	description	4	Livre Sterling
4	60	description	4	Dollar australien
46	11	description	3	Steckbare Aufgabenwartung
46	11	description	4	Entretien des tâches pour utiliser des plugins
46	1	description	3	Abrechnungsprozess
4	61	description	4	AUd
46	1	description	4	Processus de facturation
46	2	description	3	Benutzerwartung
4	62	description	4	Dollar australien
46	2	description	4	Entretien des préférences de l'utilisateur
46	3	description	3	Artikelwartung
4	63	description	4	Dollar australien
46	3	description	4	Entretien des articles
46	4	description	3	Artikeltyp Wartung
4	64	description	4	Bitcoin
46	4	description	4	Entretien du type d'articles
46	5	description	3	Artikel Kundenpreis Wartung
46	5	description	4	Entretien du prix de l'article pour l'utilisateur
46	6	description	3	Promotion Wartung
46	6	description	4	Entretien des promotions
46	7	description	3	Bestellungswartung
46	7	description	4	Entretien des commandes
46	8	description	3	Kreditkareten Wartung
46	8	description	4	Entretien des cartes bancaires
46	9	description	3	Rechnungswartung
46	9	description	4	Entretien de la facture
4	6	description	3	Won
4	6	description	4	Won
47	10	description	3	 Ein Abrechnungprozess lèuft, aber eine Prƒfung wurde als ungenehmigt befunden.
47	10	description	4	Exécution d'un processus de facturation, mais un examen s'avère non approuvé
47	11	description	3	 Ein Abrechnungprozess lèuft, eine Prƒfung ist notwendig aber wurde nicht gefunden.
47	11	description	4	Exécution d'un processus de facturation, un examen est requis mais non présent.
47	12	description	3	Ein Benutzerstatus wurde geèndert.
47	12	description	4	Le statut d'un utilisateur a été modifié.
47	13	description	3	Ein Bestellungszustand wurde geèndert.
47	13	description	4	Le statut d'une commande a été modifié.
47	14	description	3	 Ein Benutzer musste vegƒted werden, aber keine weiteren Schritte sind konfiguriert.
47	14	description	4	Un utilisateur doit être à un stade, mais il n'y a plus d'étapes configurées
47	15	description	3	Ein Partner hat eine Bezahlung, aber kein Bezahlungsinstrument.
47	15	description	4	Un paiement est prêt pour un partenaire, mais aucun instrument de paiement.
47	16	description	3	Eine Bestellung wurde manuell auf eine Rechnung hinzugefƒgt.
47	16	description	4	Un bon de commande a été manuellement appliqué à une facture.
47	17	description	3	Die Bestellungszeile wurde aktualisiert
47	17	description	4	La ligne de commande a été mise à jour
47	18	description	3	Das Abrechnunsdatung der Betellung wurde geändert
47	18	description	4	La prochaine de facturation des commandes a été modifiée
47	19	description	3	Letzer API-Aufruf, um die Benutzer Abonnement Zustandsübergänge zu erhalten
47	19	description	4	Dernier appel API pour obtenir les changements du statut des abonnements des utilisateurs
47	1	description	3	Eine voraus bezahlte Bestellung hat noch nicht abgerechneten Zeit vor dem Abrechnungsdatum
47	1	description	4	Une commande prépayée comprend du temps non facturé avant la date de traitement de la facturation
47	20	description	3	Benutzer Abonnement Status wurde geändert
47	20	description	4	Le statut de l'abonnement de l'utilisateur a changé
47	21	description	3	Benutzerkonto ist jetzt gesperrt
47	21	description	4	Le compte utilisateur est désormais bloqué
47	22	description	3	Die Hauptabonnement Markierung der Betstellung wurde geändert
47	22	description	4	La case à cocher Abonnement principal pour les commandes a été modifiée
47	23	description	3	Alle einmaligen Bestellungen die Vermittlung befanden sich im beendeten Status
50	63	description	4	Doit utiliser JQGrid pour les tableaux
47	23	description	4	Toutes les commandes uniques trouvées par la médiation avaient le statut Terminée
47	24	description	3	Eine gültige Zahlungsmethode konnte nicht gefunden werden. Die Zahlungsanforderung wurde storniert
47	24	description	4	Aucune méthode de paiement valide n'a été trouvée. La demande de paiement a été annulée
47	25	description	3	Eine neue Zeile wurde erstellt
47	25	description	4	Une nouvelle ligne a été créée
47	26	description	3	Eine abrechnete Bestellung wurde storniert, eine Kreditbestellung wurde erstellt
47	26	description	4	Une commande facturée a été annulée, un ordre de crédit a été créé
47	27	description	3	Eine Benutzer ID wurde auf die Sperrliste hinzugefügt
47	27	description	4	Un identifiant utilisateur a été ajouté à la liste noire
47	28	description	3	Eine Benutzer ID wurde von der Sperrliste entfernt
47	28	description	4	Un identifiant utilisateur a été supprimé de la liste noire
47	29	description	3	Verwendet einen Bereitstellungsbefehl mit einem UUID
47	29	description	4	A publié une commande d'approvisionnement en utilisant un UUId
47	2	description	3	 Bestellung hat keine aktive Zeit zum Zeitpunkt des Prozesses.
47	2	description	4	La commande n'a pas d'heure active à la date du traitement.
47	30	description	3	Es wurde ein Befehl für die Bereitstellung veröffentlicht
47	30	description	4	Une commande d'approvisionnement a été publiée
47	31	description	3	Der Bereitstellungsstatus einer Bestellzeile hat sich geändert
47	31	description	4	Le statut d'approvisionnement d'une ligne de commande a changé
47	32	description	3	Benutzer Abonnement Status wurde NICHT geändert
47	32	description	4	Le statut de l'abonnement de l'utilisateur n'a PAS changé
47	33	description	3	Die dynamische Balance eines Benutzers hat sich geändert
47	33	description	4	Le solde dynamique d'un utilisateur a changé
47	34	description	3	Die Rechnung wenn eine Untermarkierung sich geändert hat
47	34	description	4	La facture si la case à cocher Enfant a changé
47	35	description	4	Une commande revendeur a été créée pour l'entité racine au cours de la génération d'une facture pour une entité enfant.
47	37	description	4	Une tentative de connexion infructueuse a été effectuée.
47	3	description	3	 Mindestens ein kompletter Zeitraum ist abrechenbar.
47	3	description	4	Au moins une période complète doit être facturable.
47	4	description	3	Bereits fƒr das jetzige Datum abgrechnet.
47	4	description	4	Déjà facturée pour la date actuelle.
47	5	description	3	 Diese Bestellung musste im letzten Prozess als ausgeschlossen markiert werden.
47	5	description	4	Cette commande a dû être exclu lors du dernier traitement.
47	6	description	3	 Vorausbezahlte Bestellung wird nach dem Verfallsprozess bearbeitet.
47	6	description	4	La commande prépayée est traitée après son expiration
47	7	description	3	Eine Linie wurde als gelÖscht markiert.
47	7	description	4	Une ligne a été signalée comme supprimée.
47	8	description	3	Ein Benutzerpassword wurde geèndert.
47	8	description	4	Le mot de passe d'un utilisateur a été modifié.
47	9	description	3	Eine Linie wurde aktualisiert.
47	9	description	4	Une ligne a été mise à jour.
4	7	description	3	Schweizer Franken
4	7	description	4	Franc suisse
4	8	description	3	Schwedische Krone
4	8	description	4	couronne suédoise
4	9	description	3	Singapur Dollar
4	9	description	4	Dollar de Singapour
50	13	description	3	Selbstbelieferung von Papierrechnungen
50	13	description	4	Factures papier par courrier postal
50	13	instruction	3	Auf '1' einstellen um Rechnungen als Abrechnungsunternehmen per Email zu schicken. “0” um Rechnungen als jBilling zu schicken.
50	13	instruction	4	Configurez sur '1' pour envoyer des factures par e-mail sous le nom de la société de facturation. Sur '0' pour transmettre les factures en tant que jBilling.
50	14	description	3	Kundenanmerkungen zur Rechnung hinzufƒgen
50	14	description	4	Inclure les notes du client sur la facture
50	14	instruction	3	Auf '1' einstellen um Anmerkungen in Rechnungen anzuzeigen, “0” um dies auszuschalten.
50	14	instruction	4	Configurez sur '1' pour afficher des notes sur les factures', sur '0' pour désactiver.
50	15	description	3	Tage vor Ablauf der Auftragsbenachrichtigung
50	15	description	4	Jours avant l'expiration de la notification de la commande
50	15	instruction	3	Tage vor dem Bestellungs 'aktiv bis ' Datum um die 1. Benachrichtigung zu senden. Leer lassen, um zu deaktivieren.
50	15	instruction	4	Jours avant la date 'actives jusqu'au' des commandes pour envoyer la 1ère notification. Laissez ce champ vide pour désactiver.
50	16	description	3	Tage vor Ablauf der Auftragsbenachrichtigung 2
50	16	description	4	Jours avant l'expiration pour la notification de la commande 2
50	16	instruction	3	Tage vor dem Bestellungs 'aktiv bis ' Datum um die 2. Benachrichtigung zu senden. Leer lassen, um zu deaktivieren.
50	16	instruction	4	Jours avant la date 'actives jusqu'au' des commandes pour envoyer la 2ème notification. Laissez ce champ vide pour désactiver.
50	17	description	3	Tage vor Ablauf der Auftragsbenachrichtigung 3
50	17	description	4	Jours avant l'expiration pour la notification de la commande 3
50	17	instruction	3	Tage vor dem Bestellungs 'aktiv bis ' Datum um die 3. Benachrichtigung zu senden. Leer lassen, um zu deaktivieren.
50	17	instruction	4	Jours avant la date 'actives jusqu'au' des commandes pour envoyer la 3ème notification. Laissez ce champ vide pour désactiver.
50	18	description	3	Rechnungsnummer Prèfix 
50	18	description	4	Préfixe du numéro de facture
64	148	description	4	Népal
50	18	instruction	3	 Prefix Wert für generierte Rechnung öffentlichen Zahlen.
50	18	instruction	4	Valeur du préfixe pour les numéros publics des factures générés.
50	19	description	3	Nèchste Rechnungsnummer
50	19	description	4	Prochain numéro de facture
50	19	instruction	3	 Der aktuelle Wert für die generierte Rechnung öffentlichen Zahlen. Neuen Rechnungen wird eine öffentliche Zahl zugewiesen durch Eröhung dieses Werts.
50	19	instruction	4	La valeur actuelle pour les numéros publics des factures générés. Les nouvelles factures se verront assignées un numéro public en incrémentant cette valeur.
50	1	description	3	 Bezahlung mit dem Zahlungsprozess durchfƒhren 
50	1	description	4	Traiter le paiement avec le processus de facturation
50	20	description	3	Manuelle Rechnungslöschung
50	20	description	4	Suppression manuelle de la facture
50	20	instruction	3	Auf ' 1 ' einstellen, um es zu ermöglichen Rechnungen zu löschen, ' 0 ' um dies zu deaktivieren.
50	20	instruction	4	Configurez sur '1' pour autoriser la suppression des factures, sur '0' pour désactiver.
50	21	description	3	Rechnungserinnerungen benutzen
50	21	description	4	Utiliser des relances de facture
50	21	instruction	3	 Auf ' 1 ' einstellen um Rechnungsbenachrichtigungen zu erlauben ' 0 ' um dies zu deaktivieren.
50	21	instruction	4	Configurez sur '1' pour autoriser les notifications de relances, sur '0' pour désactiver.
50	22	description	3	Anzahl der Tage nach der Rechnungsgenerierung fƒr die erste Mahnung
50	22	description	4	Nombre de jours après la génération de la facture pour la première relance
50	23	description	3	Anzahl der Tage fƒr die nèchste Erinnerung
50	23	description	4	Nombre de jours pour la prochaine relance
50	24	description	3	Datei Fattura Fine Mese
50	24	description	4	Data Fattura Fine Mese
64	114	description	3	Kyrgyzstan
50	24	instruction	3	Auf '1' einstellen um es zu ermögliche, “0” um es zu deakivieren.
50	24	instruction	4	Configurez sur '1' pour activer, sur '0' pour désactiver.
50	25	description	3	Verwenden Sie überfällig Strafen (Zinsen).
50	25	description	4	Utiliser des pénalités pour impayés (intérêt).
50	25	instruction	3	 Auf '1' einstellen, um den Abrechnungsablauf zu ermöglichen Verzugszinsen zu berechnen, ' 0 ' um dies zu deaktivieren. Berechnung der Zinsen wird durch den gewählten Straf Plug-in bearbeitet.
50	25	instruction	4	Configurez sur '1' pour activer le processus de facturation pour calculer les intérêts sur les retards de paiement, sur '0' pour désactiver. Le calcul des intérêts est géré par le plugin des pénalités sélectionné.
50	27	description	3	Bestellungsvorgriffe verwenden.
50	27	description	4	Utiliser l'anticipation des commandes.
50	27	instruction	3	Auf '1' einstellen, um den 'OrderFilterAnticipateTask' zu verwenden, um eine Anzahl von Monate im Voraus in Rechnung zu setzen, ' 0 ' um dies zu deaktivieren. Plug-ins müssen separat konfiguriert werden.
50	27	instruction	4	Configurez sur '1' pour utiliser OrderFilterAnticipateTask pour facturer un certain nombre de mois à l'avance, sur '0' pour désactiver. Le plugin doit être configuré séparément.
50	28	description	3	Paypal Konto.
50	28	description	4	Compte PayPal.
50	28	instruction	3	PayPal Kontoname .
50	28	instruction	4	Nom du compte PayPal.
50	29	description	3	Paypal Knopf URL.
50	29	description	4	URL du bouton PayPal.
50	29	instruction	3	Eine URL, wo sich die Grafik des PayPal-Button befindet. Die Taste wird für die Kunden angezeigt, wenn sie eine Zahlung durchführen. Der Standardwert ist in der Regel die beste Option, es sei denn, eine andere Sprache wird benötigt.
50	29	instruction	4	Une URL où l'image du bouton PayPal est présente. Le bouton est affiché pour les clients lorsqu'ils effectuent un paiement. l'option Par défaut est la meilleure, sauf quand une autre langue est nécessaire.
50	2	description	3	URL der CSS Datei
50	2	description	4	URL du fichier CSS
50	30	description	3	URL für HTTP Datierungsaufruf.
50	30	description	4	URL pour le rappel des phases de vieillissement en HTTP.
50	30	instruction	3	URL des HTTP Rückrufs wenn der Datierungsprozess den Status eines Benutzers ändert.
50	30	instruction	4	URL pour le rappel au format HTTP afin d'invoquer le moment où le processus d'avancement des phases modifie le statut d'un utilisateur.
50	31	description	3	 Kontinuierliche Rechnungsdaten verwenden.
50	31	description	4	Utiliser des dates de facture continues.
50	31	instruction	3	Standard: leer. Diese Einstellung muss ein Datum (im Format JJJJ-MM-TT. Beispiel: 2000.01.31) sein, das System wird sicherstellen, dass alle Ihre Rechnungen ihre Daten in einer inkrementellen Weise haben. Jede Rechnung mit einer größeren ' ID ' wird auch ein größeres (oder gleiches) Datum haben. In anderen Worten, kann eine neue Rechnung kein früheres Datum als eine bestehende (ältere) Rechnung haben. Um diese Einstellung zu verwenden, setzen Sie diese als Kette mit dem Tag, andem es anfangen soll. Diese Einstellung wird nicht verwendet werden wenn es leer ist 
50	31	instruction	4	Espace par défaut. Cette préférence doit être une date (au format aaaa-mm-dd. Exemple : 2000-01-31); le système s'assurera que les dates de toutes vos factures sont incrémentales. Toute facture avec un 'ID' supérieur aura également une date postérieure (ou égale). En d'autres termes, ', a new invoice can not have an earlier date than an existing (older) invoice. To use this preference, set it as a string with the date where to start. This preference will not be used if blank
50	32	description	3	PDF Rechnung zur Email hinzufügen.
50	32	description	4	Attacher une facture PDF aux notifications par e-mail.
50	32	instruction	3	Auf '1' einstellen, um eine PDF-Version der Rechnung für alle Rechnungs Benachrichtigungs-E-Mails anzuhängen. ' 0 ' um dies zu deaktivieren.
50	32	instruction	4	Configurez sur '1' pour joindre une version PDF de la facture à toutes les notifications de factures par e-mail. Sur '0' pour désactiver.
50	33	description	3	 Erzwingen einer Bestellung pro Rechnung.
50	33	description	4	Forcer une commande par facture.
50	33	instruction	3	Auf '1' einstellen, um die 'zur separaten Rechnung hinzugefügt' Markierung auf einer Bestellung anzuzeigen. '0' um dies zu deaktivieren.
50	33	instruction	4	Configurez sur '1' pour afficher la case à cocher 'inclure dans une facture séparée' sur une commande. Sur '0' pour désactiver.
50	35	description	3	Bestellungs ID zu Rechnungszeilen hinzufügen.
50	35	description	4	Ajouter un ID de commande aux lignes de la facture.
50	35	instruction	3	Auf '1' einstellen , um die ID der Bestellung im Beschreibungstext der resultierenden Rechnungsposten hinzuzufügen. '0' um dies zu deaktivieren. Dies kann helfen, zu verfolgen, welche Aufträge für eine exakte Linie in einer Rechnung zuständig ist, wenn man bedenkt, dass viele Aufträge in einer einzigen Rechnung aufgenommen werden können.
50	35	instruction	4	Configurez sur '1' pour inclure l'ID de la commande dans le texte descriptif de la ligne de facture résultante. Sur '0' pour désactiver. Cela peut aider à suivre avec précision quelles sont exactement les commandes responsables pour une ligne sur une facture, en prenant en compte que de nombreuses commandes peuvent être incluses dans une facture unique.
50	36	description	3	Es Kunden erlauben Kontaktinformationen zu editieren.
50	36	description	4	Autoriser les clients à modifier ses propres coordonnées.
50	36	instruction	3	Auf '1' einstellen um es Kunden zu erlauben ihre eigenen Kontaktinformationen zu editieren. '0' um dies zu deaktivieren.
50	36	instruction	4	Configurez sur '1' pour autoriser les clients à modifier leurs propres coordonnées. Sur '0' pour désactiver.
114	14	errorMessage	5	भुगतान कार्ड नंबर मान्य नहीं है
50	38	description	3	Datierung mit dem Kundenabonnentenstatus vebinden.
50	38	description	4	Lien des phases d'avancement vers le statut d'abonné du client.
50	38	instruction	3	 Auf '1' einstellen, um den Abo-Status eines Benutzers zu ändern, wenn der Benutzer datiert wird. '0' um dies zu deaktivieren.
64	114	description	4	Kirghizistan
50	38	instruction	4	Configurez sur '1' pour modifier le statut de l'abonnement d'un utilisateur lorsqu'il y a un avancement dans les phases de ce dernier. Sur '0' pour désactiver.
50	39	description	3	Benutzer nach fehlgeschlagenen Anmeldeversuchen sperren.
50	39	description	4	Bloquer l'utilisateur après des tentatives de connexion échouées.
50	39	instruction	4	Le nombre de tentatives à autoriser avant le blocage du compte utilisateur. Un compte utilisateur bloqué le sera pendant le nombre de minutes indiquées dans Préférence 68. Pour activer cette fonction de blocage, configurer la Préférence 68 sur une valeur différente de zéro est un plus.
50	3	description	3	URL der Logografik
50	3	description	4	URL de l'image du logo
50	40	description	3	Benutzerpasswörter nach zwei Tagen ablaufen lassen.
50	40	description	4	Faire expirer les mots de passe des utilisateurs après plusieurs jours.
50	40	instruction	3	Wenn größer als Null, stellt es die Anzahl der Tage dar, für die ein Passwort gültig ist. Nach diesen Tagen, ist das Passwort abgelaufen und der Benutzer ist gezwungen, es zu ändern.
50	40	instruction	4	Si la valeur est supérieure à zéro, Il représente le nombre de jours pendant lesquels un mot de passe est valide. Une fois ces jours passés, the password is expired and the user is forced to change it.
50	41	description	3	Hauptabonnement Bestellungen benutzen.
50	41	description	4	Utiliser les commandes de l'abonnement principal.
50	41	instruction	3	Auf '1' einstellen, um die Nutzung der 'Haupt Abonnement' Markierung für Bestellungen zu ermöglichen. Diese Markierung wird nur durch das Vermittlungsverfahren gelesen, wenn festgelegt wird wo Bezahlungen eingefügt werden müssen, die von externen Ereignissen kommen.
50	41	instruction	4	Configurez sur '1' pour autoriser l'utilisation de la case à cocher 'abonnement principal' pour les commandes. Cette case est uniquement lu par le processus de médiation au moment de déterminer où placer les frais provenant d'évènements externes. 
50	42	description	3	Pro-rating benutzen.
50	42	description	4	Utiliser les paiements au prorata.
50	42	instruction	3	Auf ' 1 ' einstellen, um den Einsatz von pro-rating zu ermöglichen, um Bruchteile einer Zeitraum in Rechnung zu stellen. Zeigt das ' Zyklus ' Attribut einer Bestellung. Beachten Sie, dass Sie die entsprechenden Plug-Ins für diese Funktion konfigurieren müssen, um voll funktionsfähig zu sein.
50	42	instruction	4	Configurez sur '1' pour autoriser l'utilisation des paiements au prorata pour facturer des fractions d'une période. Afficher l'attribut 'cycle' d'une commande. Notez que vous devez configurer les plugins correspondants pour que cette fonction soit totalement fonctionnelle.
50	43	description	3	Zahlungssperrliste benutzen.
50	43	description	4	Utiliser la liste noire des paiements.
50	43	instruction	3	Wenn die Zahlung Sperrfunktion verwendet wird, dies wird auf die ID der Konfiguration des PaymentFilterTask plug-in eingestellt. Siehe den Sperrlist-Abschnitt der Dokumentation.
50	43	instruction	4	Si la fonction d'inscription sur la liste noire des paiements est utilisée, cet élément est défini comme l'ID de configuration du plugin PaymentFilterTask. Consultez la section Liste noire de la documentation.
50	44	description	3	Negative Zahlugen erlauben.
50	44	description	4	Autoriser les paiements négatifs.
50	44	instruction	3	Auf '1' einstellen um negatives Zahlugen zu erlauben. '0' um dies zu deaktivieren
50	44	instruction	4	Configurez sur '1' pour autoriser les paiements négatifs. Sur '0' pour désactiver.
50	45	description	3	Negative Rechnungszahlungen verzögern.
50	45	description	4	Retarder les paiements des factures négatives.
50	63	instruction	3	Auf '0'einstellen um den Stadardlayout zu benutzen, oder auf '1' einstellen um JQGrid auf den Tabellen der Seite zu benutzen
50	45	instruction	3	Auf ' 1 ' einstellen, um die Zahlung der negativen Rechnungsbeträge zu verzögern, wodurch die Balance auf die nächste Rechnung übertragen wird. Rechnungen, die negative Salden von anderen Rechnungen auf sie übertragen haben dürfen unverzüglich eine negative Zahlung (Kredit) durchführen, wenn nötig. '0' um dies zu deaktivieren. Präferenz 44 & 46 sind in der Regel ebenfalls aktiviert.
50	45	instruction	4	Configurez sur '1' pour retarder le paiement des montants de factures négatifs, ', causant le report su solde sur la facture suivante. Les factures ayant des soldes négatifs provenant d'autres factures sont autorisées à effectuer immédiatement un paiement négatif (crédit) si nécessaire. sur '0' pour désactiver. Les préférences 44 et 46 sont généralement également activées.
50	46	description	3	Rechnung ohne Bestellungen erlaube.
50	46	description	4	Autoriser les factures sans commandes.
50	46	instruction	3	Auf '1' einstellen, damit Rechnungen mit Negativsalden zu erlauben eine neue Rechnung zu erstellen, die nicht aus Bestellungen bestehet, so dass ihr Guthaben wird immer auf eine neue Rechnung übertragen wird, damit der Kredit erfolgen kann. '0' um dies zu deaktivieren. Präferenz 44 & 45 sind in der Regel ebenfalls aktiviert.
50	46	instruction	4	Configurez sur '1' pour autoriser les factures avec des soles négatifs à générer une nouvelle facture qui n'est pas composée de commandes afin que leurs soldes soient toujours reportés sur une nouvelle facture pour que le crédit soit pris en compte. Sur '0' pour désactiver. Les préférences 44 et 45 sont généralement également activées.
50	47	description	3	Zuletzt gelesene Vermittlungsbericht ID.
50	47	description	4	Dernier ID d'enregistrement la médiation lu.
50	47	instruction	3	ID des letzten Datensatzes durch das Vermittlungs verfahren. Dies wird verwendet, um festzustellen, welche Datensätze 'neu' sind und gelesen weren müssen.
50	47	instruction	4	ID du dernier enregistrement lu par le processus de médiation. Cela sert à déterminer quels enregistrements sont 'nouveaux' et doivent être lus.
50	48	description	3	Bereitstellung benutzen.
50	48	description	4	Utiliser l'approvisionnement.
50	48	instruction	3	Auf '1' einstellen um die Benutzung von Bereitstellungen zu erlauben. '0' um dies zu deaktivieren.
50	48	instruction	4	Configurez sur '1' pour autoriser l'utilisation de l'approvisionnement. Sur '0' pour désactiver.
50	49	description	3	Automatische Kundenaufladeschwelle.
50	49	description	4	Seuil de recharge automatique des clients.
50	49	instruction	3	Der Schwellwert für automatische Zahlungen. Prepaid-Nutzer mit einem eingestellten automatischen Wiederaufladungwert eingestellte erzeugen eine automatische Zahlung, wenn der Kontostand unter diesen Schwellwert fällt. Beachten Sie, dass Sie der AutoRechargeTask Plug-in für diese Funktion konfiguriert werden muss, um voll funktionsfähig zu sein.
50	49	instruction	4	La valeur seuil pour les paiements automatiques. Les utilisateurs prépayés avec une valeur de recharge automatique définie génèreront un paiement automatique à chaque fois que le solde du compte tombe sous ce seuil. Notez que vous devez configurer les plugins correspondants pour que le plugin AutoRechargeTask soit totalement fonctionnel.
50	4	description	3	Frist
50	4	description	4	Délai supplémentaire
50	4	instruction	3	Schonfrist in Tagen vor der Datierung eines Kunden mit einer überfälligen Rechnung.
50	4	instruction	4	Délai supplémentaire en jours avant l'avancement des phases d'un client avec un retard de paiement pour une facture.
50	50	description	3	Dezimale Rechnunsaufrundung.
50	50	description	4	Arrondissement des factures aux décimales.
50	50	instruction	3	Die Anzahl der Dezimalstellen welche auf der Rechnung ausgewiesen sind. Der Standardwert ist 2.
50	50	instruction	4	Le nombre de décimales à afficher sur la facture. Par défaut sur 2.
50	51	description	3	Minimum Balance um Datierung zu ignorieren
50	51	description	4	Solde minimum pour lequel ignorer l'avancement des phases
50	51	instruction	3	Minimum Balance, welche das Unternehmen bereit ist zu ignorieren, wenn überfällig auf einer Rechnung. Wenn dies eingestellt ist, wird dieser Wert bestimmen, ob der Nutzer hat genug Balance hat weiter zu datieren oder Benachrichtigungen für unbezahlten Rechnungen erhält
50	51	instruction	4	Solde minimum que la société est prête à ignorer en cas de retard de paiement sur une facture. Si l'option est configurée, cette valeur déterminera si l'utilisateur a un solde suffisant pour continuer à avancer dans les phases ou pour recevoir des notifications pour des factures impayées
50	52	description	3	Aktuelle Rechnung an alle überfälligen Mitteilungen anhängen.
50	52	description	4	Joindre la dernière facture à toutes les Notifications de retard de paiement.
50	52	instruction	3	Überfällig Mitteilungen 1, 2 und 3 hängen normalerweise keine Rechnungen an die E-Mail-Benachrichtigungen an. Mit dieser Einstellung kann die neueste Rechnung automatisch auf diese Mitteilungen befestigt werden.
50	52	instruction	4	Notification d'impayé. Impayés 1, 2 et 3 par défaut ne joignent pas de factures à la notification par e-mail. Avec cette préférence, la dernière facture peut être jointe automatiquement à ces notifications.
50	53	description	3	Spezifische Emails erzwingen
50	53	description	4	Forcer les e-mails uniques
50	53	instruction	3	Auf 1 einstellen, um spezifische E-Mails zwischen den Benutzern/Kunden und den Unternehmen zu erzwingen. Ansonsten auf 0 gesetzt.
50	53	instruction	4	Configurez sur '1' pour forcer les e-mails uniques parmi les utilisateurs/clients dans la société. Sinon, configurez sur '0'
50	55	description	4	Code produit unique
50	55	instruction	4	Autorise un code produit unique, S'il est défini, le code produit ou la référence interne d'un produit/article doit être forcé(e) pour être unique
50	61	description	3	Agent Provisions Typ
50	61	description	4	Type de commission des agents
50	61	instruction	3	Definiert den Provisionstyp des Standardagenten für das Unternehmen, einer dieser: RECHNUNG, ZAHLUNG
50	61	instruction	4	Il définit le type de commission des agents par défaut pour l'entité, une des : FACTURE, PAYMENT
50	62	description	4	Afficher les articles du plan sans impact
50	63	description	3	Sollte JQGrid für Tabellen benutzen
64	147	description	4	Nauru
50	63	instruction	4	Configurez sur '0' pour utiliser la disposition classique, ou sur '1' pour utiliser JQGrid  sur les tableaux du site
50	64	description	4	Royaume de destination Diameter
50	64	instruction	4	Le royaume à facturer. Il peut être utilisé pour router les messages Diameter, il faut donc que cela corresponde au royaume configuré localement.
50	65	description	4	Seuil du quota Diameter
50	65	instruction	4	Lorsque ce nombre de secondes demeure, l'unité de traitement des appels doit demander une nouvelle autorisation.
50	66	description	4	Délai supplémentaire pour la session Diameter
50	66	instruction	4	Nombre de secondes à attendre avant que les sessions Diameter soient fermées de force.
50	67	description	4	Multiplicateur/Diviseur d'unités Diameter
50	67	instruction	4	La valeur des unités reçues de la part de Diameter est divisée/multipliée par ce facteur pour convertir les secondes entrées en d'autres unités de temps. Les valeurs < 1 configurent le multiplicateur sur 1.
50	68	description	4	Durée de blocage du compte
50	68	instruction	4	Nombre de minutes pendant lesquelles un compte utilisateur restera bloqué après que le nombre de tentatives autorisées soit épuisé (Préférence 39).
50	69	description	4	Notification de facture ITG
50	69	instruction	4	Actives les notifications de factures ITG (Générateur de modèles de factures).
50	70	description	4	Faire expirer les comptes inactifs après plusieurs jours.
50	70	instruction	4	Nombre de jours après lesquels un compte utilisateur devient inactif. Cela désactiver la capacité de cet utilisateur à se connecter à jBilling.
52	12	description	3	Rechnung (Papier)
52	12	description	4	Facture (papier)
52	13	description	3	Bestellung verfèllt bald. Schritt 1
52	13	description	4	Commande sur le point d'expirer. Étape 1
52	14	description	3	Bestellung verfèllt bald. Schritt 2
52	14	description	4	Commande sur le point d'expirer. Étape 2
52	15	description	3	Bestellung verfèllt bald. Schritt 3
52	15	description	4	Commande sur le point d'expirer. Étape 3
52	16	description	3	Payment (erfolgreich)
52	16	description	4	Paiement (réussi)
52	17	description	3	Bezahlung (fehlgeschlagen)
52	17	description	4	Paiement (échec)
52	18	description	4	Relance de facture
52	19	description	3	Kreditkarte aktualisieren
52	19	description	4	Mettre à jour la carte bancaire
52	1	description	3	Rechnung (email)
52	1	description	4	Facture (e-mail)
52	20	description	3	Passwort verloren
52	20	description	4	Mot de passe perdu
52	22	description	3	Bezahlung eingegeben
52	22	description	4	Paiement saisi
52	23	description	3	Bezahlung (Rückerstattung)
52	23	description	4	Paiement (remboursement)
52	24	description	4	Seuil inférieur au solde
52	25	description	4	Consommation du regroupement d'utilisation
52	26	description	4	Limitation de crédit 1
52	27	description	4	Limitation de crédit 2
52	2	description	3	Benutzer neu aktiviert
52	2	description	4	Utilisateur réactivé
52	3	description	3	Benutzer ƒberfèllig
52	3	description	4	Retard de paiement du client
52	4	description	3	Benutzer ƒberfèllig 2
52	4	description	4	Retard de paiement 2 du client
52	5	description	3	Benutzer ƒberfèllig 3
52	5	description	4	Retard de paiement 3 du client
52	6	description	3	Benutzer gesperrt
52	6	description	4	Utilisateur suspendu
52	7	description	3	Benutzer gesperrt 2
52	7	description	4	Utilisateur suspendu 2
52	8	description	3	Benutzer gesperrt 3
52	8	description	4	Utilisateur suspendu 3
52	9	description	3	Benutzer gelÖscht
52	9	description	4	Utilisateur supprimé
59	100	description	3	Agentmenü erstellen
59	100	description	4	Afficher le menu Agent
59	101	description	3	Agent erstellen
59	101	description	4	Créer un agent
59	102	description	4	Modifier l'agent
59	103	description	4	Supprimer l'agent
59	104	description	4	Voir les détails de l'agent
59	10	description	3	Kunden erstellen
59	10	description	4	Créer un client
59	110	description	3	Zu Unterkonto wechseln
59	110	description	4	Passer au sous-compte
59	111	description	3	Zu anderem Benutzer wechseln
59	111	description	4	Passer à n'importe quel utilisateur
59	11	description	3	Kunden editieren
59	11	description	4	Modifier le client
59	120	description	3	Web Service API Zugriff
59	120	description	4	Accès l'API du service web
59	121	description	3	Abrechnungszeitraum des Kunden editieren
59	121	description	4	Modifier le cycle de facturation du client
59	12	description	3	Kunden löschen
59	12	description	4	Supprimer le client
59	130	description	4	Ajouter un actif
59	131	description	4	Modifier l'actif
59	132	description	4	Supprimer l'actif
59	133	description	4	Télécharger le fichier des actifs
59	13	description	3	Kunden prüfen
59	13	description	4	Inspecter le client
59	140	description	4	Ajouter un code utilisateur
59	141	description	4	Modifier le code utilisateur
59	142	description	4	Voir le code utilisateur
59	143	description	4	Assigner le code utilisateur à l'entité
59	144	description	4	Modifier le code utilisateur pour l'entité
59	145	description	4	Forçage du mot de passe
59	14	description	3	Kunden sperren
59	14	description	4	Inscrire le client sur la liste noire
59	151	description	4	Créer une réduction
59	152	description	4	Supprimer la réduction
59	153	description	4	Modifier la réduction
59	15	description	3	Kundendetails ansehen
59	15	description	4	Voir les informations du client
59	160	description	4	Voir mon compte
59	161	description	4	Modifier le mot de passe
59	162	description	4	Modifier mon compte
59	16	description	3	Kunden CSV herunterladen
59	16	description	4	Télécharger le CSV du client
59	170	description	4	Modifier les requêtes générales
59	17	description	3	Alle Kunden anzeigen
59	17	description	4	Voir tous les clients
59	180	description	4	Modifier les modèles de factures
59	181	description	4	Ajouter des modèles de facture
59	182	description	4	Liste des modèles de factures
59	183	description	4	Supprimer des modèles de factures
59	18	description	3	Alle Kunden Unterkonten anzeigen
59	18	description	4	Voir les sous-comptes du client
59	19	description	3	Nächstes Rechnungsdatum editieren
59	19	description	4	Modifier la date de la prochaine facture
59	20	description	3	Bestellung erstellen
59	20	description	4	Créer une commande
59	21	description	3	Bestellung editieren
59	21	description	4	Modifier la commande
59	22	description	3	Bestellung löschen
59	22	description	4	Supprimer la commande
59	23	description	3	Rechnung für Bestellung erzeugen
59	23	description	4	Générer une facture pour la commande
59	24	description	3	Bestellungsdetails anzeigen
59	24	description	4	Voir les détails de la commande
59	25	description	3	Bestellungs CSV herunterladen
59	25	description	4	Télécharger le CSV des commandes
59	26	description	3	Zeilenpreis editieren
59	26	description	4	Modifier le prix de la ligne
59	27	description	3	Zeilenbeschreibung editieren
59	27	description	4	Modifier la description de la ligne
59	28	description	3	Alle Kunden anzeigen
59	28	description	4	Voir tous les clients
59	29	description	3	Alle Kunden Unterkonten anzeigen
59	29	description	4	Voir les sous-comptes du client
59	30	description	3	Zahlung erstellen
59	30	description	4	Créer un paiement
59	31	description	3	Bezahlung editieren
59	31	description	4	Modifier le paiement.
59	32	description	3	Zahlung löschen
59	32	description	4	Supprimer le paiement
59	33	description	3	Zahlung mit der Rechnung verbinden
59	33	description	4	Il associe les paiements aux factures.
59	34	description	3	Zahlungsdetails anzeigen
59	34	description	4	Voir les détails du paiement
59	35	description	3	Zahlungs CSV herunterladen
59	35	description	4	Télécharger le CSV des paiements
59	36	description	3	Alle Kunden anzeigen
59	36	description	4	Voir tous les clients
59	37	description	3	Kunden Unterkonten anzeigen
59	37	description	4	Voir les sous-comptes du client
59	40	description	3	Produkt erstellen
59	40	description	4	Créer un produit
59	41	description	3	Produkt editieren
59	41	description	4	Modifier le produit
59	42	description	3	Produkt löschen
59	42	description	4	Supprimer le produit
59	43	description	3	Produkt Details anzeigen
59	43	description	4	Voir les détails du produit
59	44	description	3	Zahlungs CSV anzeigen
59	44	description	4	Télécharger le CSV des paiements
59	50	description	3	Produktkategorie erstellen
59	50	description	4	Créer une catégorie de produit
59	51	description	3	Produktkategorie erstellen
59	51	description	4	Modifier la catégorie de produit
59	52	description	3	Produktkategorie löschen
59	52	description	4	Supprimer la catégorie de produit
59	53	description	4	Modifier les statuts de la catégorie
59	54	description	4	Modifier les meta-champs de la catégorie
59	60	description	3	Plan erstellen
59	60	description	4	Créer un plan
59	61	description	3	Plan editieren
59	61	description	4	Modifier le plan
59	62	description	3	Plan löschen
59	62	description	4	Supprimer le plan
59	63	description	3	Plan details anzeigen
59	63	description	4	Voir les détails du plan
59	70	description	3	Rechnung löschen
59	70	description	4	Supprimer la facture
59	71	description	3	Rechnungsmitteilung schicken
59	71	description	4	Envoi d'une notification pour la facture
59	72	description	3	Rechnungsdetails anzeigen
59	72	description	4	Voir les détails de la facture
59	73	description	3	Rechnungs CSV anzeigen
59	73	description	4	Télécharger le CSV des factures
59	74	description	3	Alle Kunden anzeigen
59	74	description	4	Voir tous les clients
59	75	description	3	Kundenunterkonten anzeigen
59	75	description	4	Voir les sous-comptes du client
59	80	description	3	Review Genehmigen/nicht genehmigen
59	80	description	4	Approuver/Désapprouver l'examen
59	900	description	4	Afficher le menu Approvisionnement
59	901	description	4	Afficher le menu Agent
59	902	description	4	Afficher le menu Réductions
59	90	description	3	Kundenmenü anzeigen
59	90	description	4	Afficher le menu Client
59	91	description	3	Rechnungsmenü anzeigen
59	91	description	4	Afficher le menu Factures
59	92	description	3	Bestellungsmenü anzeigen
59	92	description	4	Afficher le menu Commande
114	15	errorMessage	1	ABA Routing or Bank Account Number can only be digits
59	94	description	3	Abrechnungsmenü anzeigen
59	94	description	4	Afficher le menu Facturation
59	95	description	3	Vermittlungsmenü anzeigen
59	95	description	4	Afficher le menu Médiation
59	96	description	3	Berichtmenü anzeigen
59	96	description	4	Afficher le menu Rapports
59	97	description	3	Produktmenü anzeigen
59	97	description	4	Afficher le menu Produits
59	98	description	3	Planmenü anzeigen
59	98	description	4	Afficher le menu Plans
59	99	description	3	Einstellungsmenü anzeigen
59	99	description	4	Afficher le menu Configuration
60	1	description	3	Ein interner Benutzer mit allen Rechten
60	1	description	4	Un utilisateur interne disposant de toutes les permissions
60	1	title	3	Intern
60	1	title	4	Interne
60	2	description	3	Der super User eines Unternehmens
60	2	description	4	Le super utilisateur d'une entité
60	2	title	3	Super User
60	2	title	4	Super utilisateur
60	3	description	3	Ein Buchhalter
60	3	description	4	Un employé chargé de la facturation
60	3	title	3	Angestellter
60	3	title	4	Employé
60	4	description	3	Ein Agent der Kunden bringen wird
60	4	description	4	Un agent qui ramènera des clients
60	4	title	3	Agent
60	5	description	3	Ein Kunde der sein/ihr Konto abfragen wird
60	5	description	4	Un client qui cherchera son compte
60	5	title	3	Kunde
60	5	title	4	Client
60	60	description	3	Der Super User eines Unternehmens
60	60	description	4	Le super utilisateur d'une entité
60	60	title	3	Super User
60	60	title	4	Super utilisateur
60	61	description	3	ein Buchhalterc
60	61	description	4	Un employé chargé de la facturation
60	61	title	3	Angestellter
60	61	title	4	Employé
60	62	description	3	 Ein Kunde, der sein/ihr Konto abfragen wird
60	62	description	4	Un client qui cherchera son compte
60	62	title	3	Kunde
60	62	title	4	Client
60	63	description	3	Ein Agent der Kunden bringen wird
60	63	description	4	Un agent qui ramènera des clients
60	63	title	3	Agent
60	63	title	4	Agent
60	70	description	4	Le super utilisateur d'une entité
60	70	title	4	Super utilisateur
60	71	description	4	Un employé chargé de la facturation
60	71	title	4	Employé
60	72	description	4	Un client qui cherchera son compte
60	72	title	4	Client
60	73	description	4	Un agent qui ramènera des clients
60	73	title	4	Agent
60	74	description	4	Le super utilisateur d'une entité
60	74	title	4	Super utilisateur
60	75	description	4	Un employé chargé de la facturation
60	75	title	4	Employé
60	76	description	4	Un client qui cherchera son compte
60	76	title	4	Client
60	77	description	4	Un agent qui ramènera des clients
60	77	title	4	Agent
60	78	description	4	Le super utilisateur d'une entité
60	78	title	4	Super utilisateur
60	79	description	4	Un employé chargé de la facturation
60	79	title	4	Employé
60	80	description	4	Un client qui cherchera son compte
60	80	title	4	Client
60	81	description	4	Un agent qui ramènera des clients
60	81	title	4	Agent
60	82	description	4	Le super utilisateur d'une entité
60	82	title	4	Super utilisateur
60	83	description	4	Un employé chargé de la facturation
60	83	title	4	Employé
60	84	description	4	Un client qui cherchera son compte
60	84	title	4	Client
60	85	description	4	Un agent qui ramènera des clients
60	85	title	4	Agent
60	87	description	4	Le super utilisateur d'une entité
60	87	title	4	Super utilisateur
60	88	description	4	Un employé chargé de la facturation
60	88	title	4	Employé
60	89	description	4	Un client qui cherchera son compte
60	89	title	4	Client
60	90	description	4	Un agent qui ramènera des clients
60	90	title	4	Agent
60	91	description	4	Le super utilisateur d'une entité
60	91	title	4	Super utilisateur
64	148	description	3	Nepal
60	92	description	4	Un employé chargé de la facturation
60	92	title	4	Employé
60	93	description	4	Un client qui cherchera son compte
60	93	title	4	Client
60	94	description	4	Un agent qui ramènera des clients
60	94	title	4	Agent
60	95	description	4	Le super utilisateur d'une entité
60	95	title	4	Super utilisateur
60	96	description	4	Un employé chargé de la facturation
60	96	title	4	Employé
60	97	description	4	Un client qui cherchera son compte
60	97	title	4	Client
60	98	description	4	Un agent qui ramènera des clients
60	98	title	4	Agent
6	1	description	3	Monat
6	1	description	4	Mois
6	2	description	3	Woche
6	2	description	4	Semaine
6	3	description	3	Tag
6	3	description	4	Jour
64	100	description	3	Indonesien
64	100	description	4	Indonésie
64	101	description	3	Iran
64	101	description	4	Iran
64	102	description	3	Irak
64	102	description	4	Irak
64	103	description	3	Irland
64	103	description	4	Irlande
64	104	description	3	Israel
64	104	description	4	Israël
64	105	description	3	Italien
64	105	description	4	Italie
64	106	description	3	Jamaica
64	106	description	4	Jamaïque
64	107	description	3	Japan
64	107	description	4	Japon
64	108	description	3	Jordan
64	108	description	4	Jordanie
64	109	description	3	Kazakhstan
64	109	description	4	Kazakhstan
64	10	description	3	Argentinien
64	10	description	4	Argentine
64	110	description	3	Kenia
64	110	description	4	Kenya
64	111	description	3	Kiribati
64	111	description	4	Kiribati
64	112	description	3	Korea
64	112	description	4	Corée
64	113	description	3	Kuwait
64	113	description	4	Koweït
64	115	description	4	Laos
64	116	description	3	Latvia
64	116	description	4	Lettonie
64	117	description	3	Lebanon
64	117	description	4	Liban
64	118	description	3	Lesotho
64	118	description	4	Lesotho
64	119	description	3	Liberia
64	119	description	4	Liberia
64	11	description	3	Armenien
64	11	description	4	Arménie
64	120	description	3	Libia
64	120	description	4	Libye
64	121	description	3	Liechtenstein
64	121	description	4	Liechtenstein
64	122	description	3	Lithuanien
64	122	description	4	Lituanie
64	123	description	3	Luxemburg
64	123	description	4	Luxembourg
64	124	description	3	Macao SAR
64	124	description	4	Macao - Région administrative spéciale
64	125	description	3	Mazedonien,ehemalige Jugoslavische Republik
64	125	description	4	Macédoine, ancienne République yougoslave de
64	126	description	3	Madagaskar
64	126	description	4	Madagascar
64	127	description	3	Malawi
64	127	description	4	Malawi
64	128	description	3	Malaysia
64	128	description	4	Malaisie
64	129	description	3	Maldiven
64	129	description	4	Maldives
64	12	description	3	Aruba
64	12	description	4	Aruba
64	130	description	3	Mali
64	130	description	4	Mali
64	131	description	3	Malta
64	131	description	4	Malte
64	132	description	3	Marshall Inseln
64	132	description	4	Îles Marshall
64	133	description	3	Martinique
64	133	description	4	Martinique
64	134	description	3	Mauritanien
64	134	description	4	Mauritanie
64	135	description	3	Mauritius
64	135	description	4	Maurice
64	136	description	3	Mayotte
64	136	description	4	Mayotte
64	137	description	3	Mexiko
64	137	description	4	Mexique
64	138	description	3	Mikronesien
64	138	description	4	Micronésie
64	139	description	3	Moldawien
64	139	description	4	Moldavie
64	13	description	3	Australia
64	13	description	4	Australie
64	140	description	3	Monaco
64	140	description	4	Monaco
64	141	description	3	Mongolien
64	141	description	4	Mongolie
64	142	description	3	Montserrat
64	142	description	4	Montserrat
64	143	description	3	Marokko
64	143	description	4	Maroc
64	144	description	3	Mozambique
64	144	description	4	Mozambique
64	145	description	3	Myanmar
64	145	description	4	Myanmar
64	146	description	3	Namibien
64	146	description	4	Namibie
64	147	description	3	Nauru
64	149	description	3	Holland
64	149	description	4	Pays-Bas
64	14	description	3	àsterreich
64	14	description	4	Autriche
64	150	description	3	Niederlèndische Antillen
64	150	description	4	Antilles néerlandaises
64	151	description	3	Neukaledonien
64	151	description	4	Nouvelle-Calédonie
64	152	description	3	Neuseeland
64	152	description	4	Nouvelle-Zélande
64	153	description	3	Nicaragua
64	153	description	4	Nicaragua
64	154	description	3	Niger
64	154	description	4	Niger
64	155	description	3	Nigeria
64	155	description	4	Nigéria
64	156	description	3	Niue
64	156	description	4	Niue
64	157	description	3	Norfolk Island
64	157	description	4	Île Norfolk
64	158	description	3	Nord Korea
64	158	description	4	Corée du Nord
64	159	description	3	NÖrdliche Mariana Islands
64	159	description	4	Îles Mariannes du Nord
64	15	description	3	Azerbaijan
64	15	description	4	Azerbaïdjan
64	160	description	3	Norwegen
64	160	description	4	Norvège
64	161	description	3	Oman
64	161	description	4	Oman
64	162	description	3	Pakistan
64	162	description	4	Pakistan
64	163	description	3	Palau
64	163	description	4	Palaos
64	164	description	3	Panama
64	164	description	4	Panama
64	165	description	3	Papua Neu Guinea
64	165	description	4	Papouasie-Nouvelle-Guinée
64	166	description	3	Paraguay
64	166	description	4	Paraguay
64	167	description	3	Peru
64	167	description	4	Pérou
64	168	description	3	Philippien
64	168	description	4	Philippines
64	169	description	3	Pitcairn Islands
64	169	description	4	Îles Pitcairn
64	16	description	3	Bahamas
64	16	description	4	Bahamas
64	170	description	3	Polen
64	170	description	4	Pologne
64	171	description	3	Portugal
64	171	description	4	Portugal
64	172	description	3	Puerto Rico
64	172	description	4	Porto Rico
64	173	description	3	Qatar
64	173	description	4	Qatar
64	174	description	3	Reunion
64	174	description	4	Réunion
64	175	description	3	Romènien
64	175	description	4	Roumanie
64	176	description	3	Russland
64	176	description	4	Russie
64	177	description	3	Rwanda
64	177	description	4	Rwanda
64	178	description	3	Samoa
64	178	description	4	Samoa
64	179	description	3	San Marino
64	179	description	4	San Marin
64	17	description	3	Bahrain
64	17	description	4	Bahreïn
64	180	description	3	Sao Tome und Principe
64	180	description	4	Sao Tomé-et-Principe
64	181	description	3	Saudi Arabien
64	181	description	4	Arabie Saoudite
64	182	description	3	Senegal
64	182	description	4	Sénégal
64	183	description	3	Serben und Montenegro
64	183	description	4	Serbie-et-Monténégro
64	184	description	3	Seychellen
64	184	description	4	Seychelles
64	185	description	3	Sierra Leone
64	185	description	4	Sierra Leone
64	186	description	3	Singapur
64	186	description	4	Singapour
64	187	description	3	Slovakien
64	187	description	4	Slovaquie
64	188	description	3	Slovenien
64	188	description	4	Slovénie
64	189	description	3	Solomon Islands
64	189	description	4	Îles Salomon
64	18	description	3	Bangladesch
64	18	description	4	Bangladesh
64	190	description	3	Somalien
64	190	description	4	Somalie
64	191	description	3	Sƒdafrika
64	191	description	4	Afrique du Sud
64	192	description	3	Sƒdgeorgien und sƒdliche Sandwichinseln
64	192	description	4	Géorgie du Sud-et-les Îles Sandwich du Sud
64	193	description	3	Spanien
64	193	description	4	Espagne
64	194	description	3	Sri Lanka
64	194	description	4	Sri Lanka
64	195	description	3	St. Helena
64	195	description	4	Sainte- Hélène
64	196	description	3	St. Kitts und Nevis
64	196	description	4	Saint- Christophe-et-Niévès
64	197	description	3	St. Lucia
64	197	description	4	Saint- Lucie
64	198	description	3	St. Pierre und Miquelon
64	198	description	4	Saint- Pierre-et-Miquelon
64	199	description	3	St. Vincent and the Grenadines
64	199	description	4	Saint- Vincent-et-les-Grenadines
64	19	description	3	Barbados
64	19	description	4	Barbade
64	1	description	3	Afghanistan
64	1	description	4	Afghanistan
64	200	description	3	Sudan
64	200	description	4	Soudan
64	201	description	3	Suriname
64	201	description	4	Suriname
64	202	description	3	Svalbard und Jan Mayen
64	202	description	4	Svalbard et Jan Mayen
64	203	description	3	Swaziland
64	203	description	4	Swaziland
64	204	description	3	Schweden
64	204	description	4	Suède
64	205	description	3	Schweiz
64	205	description	4	Suisse
64	206	description	3	Syrien
64	206	description	4	Syrie
64	207	description	3	Taiwan
64	207	description	4	Taïwan
64	208	description	3	Tajikistan
64	208	description	4	Tadjikistan
64	209	description	3	Tanzania
64	209	description	4	Tanzanie
64	20	description	3	Belarus
64	20	description	4	Biélorussie
64	210	description	3	Thailand
64	210	description	4	Thaïlande
64	211	description	3	Togo
64	211	description	4	Togo
64	212	description	3	Tokelau
64	212	description	4	Tokelau
64	213	description	3	Tonga
64	213	description	4	Tonga
64	214	description	3	Trinidad und Tobago
64	214	description	4	Trinité-et-Tobago
64	215	description	3	Tunesien
64	215	description	4	Tunisie
64	216	description	3	Turkei
64	216	description	4	Turquie
64	217	description	3	Turkmenistan
64	217	description	4	Turkménistan
64	218	description	3	Turks und Caicos Islands
64	218	description	4	Îles Turques-et-Caïques
64	219	description	3	Tuvalu
64	219	description	4	Tuvalu
64	21	description	3	Belgien
64	21	description	4	Belgique
64	220	description	3	Uganda
64	220	description	4	Ouganda
64	221	description	3	Ukraine
64	221	description	4	Ukraine
64	222	description	3	Vereinigte Arabische Emirate
64	222	description	4	Émirats Arabes Unis
64	223	description	3	Vereinigtes KÖnigreich
64	223	description	4	Royaume-Uni
64	224	description	3	Vereinigte Staaten
64	224	description	4	États-Unis
64	225	description	3	Amerikanisch Ozeanien
64	225	description	4	Îles mineures éloignées des États-Unis
64	226	description	3	Uruguay
64	226	description	4	Uruguay
64	227	description	3	Uzbekistan
64	227	description	4	Ouzbékistan
64	228	description	3	Vanuatu
64	228	description	4	Vanuatu
64	229	description	3	Vatikanstadt
64	229	description	4	Cité du Vatican
64	22	description	3	Belize
64	22	description	4	Belize
64	230	description	3	Venezuela
64	230	description	4	Venezuela
64	231	description	3	Vietnam
64	231	description	4	Vietnam
64	232	description	3	Britische Junferninseln
64	232	description	4	Îles Vierges britanniques
64	233	description	3	Jungferninseln
64	233	description	4	Îles Vierges
64	234	description	3	Wallis und Futuna
64	234	description	4	Wallis-et-Futuna
64	235	description	3	Yemen
64	235	description	4	Yémen
64	236	description	3	Zambia
64	236	description	4	Zambie
64	237	description	3	Zimbabwe
64	237	description	4	Zimbabwe
64	23	description	3	Benin
64	23	description	4	Benin
64	24	description	3	Bermudas
64	24	description	4	Bermudes
64	25	description	3	Bhutan
64	25	description	4	Bhoutan
64	26	description	3	Bolivien
64	26	description	4	Bolivie
64	27	description	3	Bosnien und Herzegovina
64	27	description	4	Bosnie-Herzégovine
64	28	description	3	Botswana
64	28	description	4	Botswana
64	29	description	3	Bouvet Insel
64	29	description	4	Île Bouvet
64	2	description	3	Albanien
64	2	description	4	Albanie
64	30	description	3	Brazilien
64	30	description	4	Brésil
64	31	description	3	Britisches Territorium im Indischen Ozean
64	31	description	4	Territoire britannique de l'Océan Indien
64	32	description	3	Brunei
64	32	description	4	Brunei
64	33	description	3	Bulgarien
64	33	description	4	Bulgarie
64	34	description	3	Burkina Faso
64	34	description	4	Burkina Faso
64	35	description	3	Burundi
64	35	description	4	Burundi
64	36	description	3	Kambodien
64	36	description	4	Cambodge
64	37	description	3	Karmun
64	37	description	4	Cameroun
64	38	description	3	Kanada
64	38	description	4	Canada
64	39	description	3	Kap Verde
64	39	description	4	Cap-Vert
64	3	description	3	Algerien
64	3	description	4	Algérie
64	40	description	3	Kaimaninseln
64	40	description	4	Îles Caïmans
64	41	description	3	Zentralfrikanische Republik
64	41	description	4	République centrafricaine
64	42	description	3	Chad
64	42	description	4	Tchad
64	43	description	3	Chile
64	43	description	4	Chili
64	44	description	3	China
64	44	description	4	Chine
64	45	description	3	Weihnachtsinsel
64	45	description	4	Île Christmas
64	46	description	3	Cocos - Keeling Islands
64	46	description	4	Îles Cocos
64	47	description	3	Kolumbien
64	47	description	4	Colombie
64	48	description	3	Komoren
64	48	description	4	Comores
64	49	description	3	Kongo
64	49	description	4	Congo
64	4	description	3	Amerikanisch-Samoa
64	4	description	4	Samoa américaines
64	50	description	3	Cook Inseln
64	50	description	4	Îles Cook
64	51	description	3	Costa Rica
64	51	description	4	Costa Rica
64	52	description	3	Cote d Ivoire
64	52	description	4	Côte d'Ivoire
64	53	description	3	Kroatien
64	53	description	4	Croatie
64	54	description	3	Kuba
64	54	description	4	Cuba
64	55	description	3	Zypern
64	55	description	4	Chypre
64	56	description	3	Tschechische Republik
64	56	description	4	République Tchèque
64	57	description	3	Kongo - DRC
64	57	description	4	Congo - République démocratique du Congo
64	58	description	3	Dènemarkd
64	58	description	4	Danemark
64	59	description	3	Djibouti
64	59	description	4	Djibouti
64	5	description	3	Andorra
64	5	description	4	Andorre
64	60	description	3	Dominica
64	60	description	4	Dominique
64	61	description	3	Dominikanische Republike
64	61	description	4	République Dominicaine
64	62	description	3	ost Timor
64	62	description	4	Timor oriental
64	63	description	3	Equador
64	63	description	4	Equateur
64	64	description	3	Çgypten
64	64	description	4	Égypte
64	65	description	3	El Salvador
64	65	description	4	El Salvador
64	66	description	3	quatorialguinea
64	66	description	4	Guinée équatoriale
64	67	description	3	Eritrea
64	67	description	4	Érythrée
64	68	description	3	Estonien
64	68	description	4	Estonie
64	69	description	3	Ethiopien
64	69	description	4	Éthiopie
64	6	description	3	Angola
64	6	description	4	Angola
64	70	description	3	Malediven
64	70	description	4	Îles Malouines
64	71	description	3	FèrÖr
64	71	description	4	Îles Féroé
64	72	description	3	Fiji Inseln
64	72	description	4	Îles Fidji
64	73	description	3	Finland
64	73	description	4	Finlande
64	74	description	3	Frankreich
64	74	description	4	France
64	75	description	3	FranzÖsisch-Guayana
64	75	description	4	Guyane
64	76	description	3	FranzÖsisch Polynesien
64	76	description	4	Polynésie française
64	77	description	3	FranzÖsische Sƒd- und Antartisgebiete
64	77	description	4	Terres australes et antarctiques françaises
64	78	description	3	Gabon
64	78	description	4	Gabon
64	79	description	3	Gambia
64	79	description	4	Gambie
64	7	description	3	Anguilla
64	7	description	4	Anguilla
64	80	description	3	Georgien
64	80	description	4	Géorgie
64	81	description	3	Deutschland
64	81	description	4	Allemagne
64	82	description	3	Ghana
64	82	description	4	Ghana
64	83	description	3	Gibraltar
64	83	description	4	Gibraltar
64	84	description	3	Griechenland
64	84	description	4	Grèce
64	85	description	3	GrÖnland
64	85	description	4	Groenland
64	86	description	3	Grenada
64	86	description	4	Grenade
64	87	description	3	Guadeloupe
64	87	description	4	Guadeloupe
64	88	description	3	Guam
64	88	description	4	Guam
64	89	description	3	mala
64	89	description	4	Guatemala
64	8	description	3	Antarktik
64	8	description	4	Antarctique
64	90	description	3	Guinea
64	90	description	4	Guinée
64	91	description	3	Guinea-Bissau
64	91	description	4	Guinée-Bissau
64	92	description	3	Guyana
64	92	description	4	Guyane
64	93	description	3	Haiti
64	93	description	4	Haïti
64	94	description	3	Heard Inseln und McDonald Inseln
64	94	description	4	Îles Heard-et-MacDonald
64	95	description	3	Honduras
64	95	description	4	Honduras
64	96	description	3	Hong Kong SAR
64	96	description	4	Hong Kong - Région administrative spéciale
64	97	description	3	Ungarn
64	97	description	4	Hongrie
64	98	description	3	Island
64	98	description	4	Islande
64	99	description	3	Indien
64	99	description	4	Inde
64	9	description	3	Antigua und Barbuda
64	9	description	4	Antigua-et-Barbuda
6	4	description	3	Jahr
6	4	description	4	Année
6	5	description	3	Zeimal monatlich
6	5	description	4	Deux fois par mois
7	1	description	3	Email
7	1	description	4	E-mail
7	2	description	3	Papoer
7	2	description	4	Papier
7	3	description	3	Email + Papier
7	3	description	4	E-mail + Papier
81	1	description	3	Aktiv
81	1	description	4	Actif
81	2	description	3	Anstehende Kƒndigung
81	2	description	4	Désabonnement imminent
81	3	description	3	Gekƒndigt
81	3	description	4	Désabonné
81	4	description	3	Anstehender Verfall
81	4	description	4	Expiration imminente
81	5	description	3	verfallen
81	5	description	4	Expiré
81	6	description	3	Nichtabonnentend
81	6	description	4	Non-abonné
81	7	description	3	Eingestellt
81	7	description	4	Interrompu
88	1	description	3	Aktiv
88	1	description	4	Actif
88	2	description	3	Inaktiv
88	2	description	4	Inactif
88	3	description	3	ausstehend aktiv
88	3	description	4	En attente d'être actif
88	4	description	3	ausstehend inaktiv
88	4	description	4	En attente d'être inactif
88	5	description	3	Fehlgeschlagen
88	5	description	4	Échec
88	6	description	3	nicht verfƒgbar
88	6	description	4	Indisponible
90	1	description	3	Bezahlt
90	1	description	4	Payée
90	2	description	3	Unbezahlt
90	2	description	4	Impayée
90	3	description	3	Übertragen
90	3	description	4	Reportée
91	1	description	3	Fertig und abrechenbar
91	1	description	4	Terminée et facturable
91	2	description	3	Fertig und nicht abrechenbar
91	2	description	4	Terminée et non facturable
91	3	description	3	Fehler gefunden
91	3	description	4	Erreur détectée
91	4	description	3	Fehler gemeldet
91	4	description	4	Erreur déclarée
9	1	description	3	Aktiv
9	1	description	4	Actif
92	1	description	3	Laufend
92	1	description	4	En cours d'exécution
92	2	description	3	Fertig: Erfolgreich
92	2	description	4	Terminée : succès
92	3	description	3	Fertig: Fehlgeschlagen
92	3	description	4	Terminée : échec
114	15	errorMessage	3	ABA Routing oder Bank Kontonummer kann nur Zahlen sein
50	51	description	1	Minimum Balance for which to ignore ageing
50	51	instruction	1	Minimum Balance that the business is willing to ignore if overdue on an Invoice. If set, this value will determine if the User has enough balance to continue to Ageing or receive Notifications for Unpaid Invoices
52	22	description	1	Payment Entered
50	52	description	1	Attach latest Invoice to all Overdue Notification.
50	52	instruction	1	Overdue Notification Overdue 1 2 and 3 by default do not attach Invoices to the notification email. With this preference, the latest Invoice can be attached to such notifications automatically.
24	97	title	1	Penalty Task on Overude Invoice
24	97	description	1	This task is responsible for applying a %-age or a fixed amount penalty on an Overdue Invoice. This task is powerful because it performs this action just before the Billing process collects orders.
24	101	title	1	Event based custom notification task
24	101	description	1	The event based custom notification task takes the custom notification message and does the notification when the internal event occurred
50	53	description	1	Force Unique Emails
50	53	instruction	1	Set to 1 in order to force unique emails among the users/customers into the company. Set to 0 otherwise.
24	105	title	1	Suretax Plugin
24	105	description	1	This plugin adds tax lines to invoice by consulting the Suretax Engine.
50	31	instruction	1	Default blank. This preference has to be a date (In the format yyyy-mm-dd. Example: 2000-01-31), the system will make sure that all your invoices have their dates in an incremental way. Any invoice with a greater 'ID' will also have a greater (or equal) date. In other words, a new invoice can not have an earlier date than an existing (older) invoice. To use this preference, set it as a string with the date where to start. This preference will not be used if blank
52	23	description	1	Payment (refund)
35	6	description	1	Discover
35	6	description	2	Discover
18	4	description	1	Discount
6	5	description	1	Semi-Monthly
59	121	description	1	Edit billing cycle of customer
35	15	description	1	Credit
24	107	title	1	Credit on negative invoice
24	107	description	1	This plug-in will set the balance and total of a negative invoice to 0 and create a 'credit' payment for the remaining amount.
24	108	title	1	User Balance threshold notification task
24	108	description	1	A pluggable task of the type InternalEventsTask to monitor if users pre-paid balance is below a threshold level and send notifications.
104	5	description	1	Custom Notifications
52	24	description	1	Balance Below Threshold
24	109	title	1	Custom user notifications per ageing steps
24	109	description	1	This plug-in provides mapping between the user status(ageing steps) and notifications that needs to be sent for each status
50	55	description	1	Unique product code
50	55	instruction	1	Allows unique product code, If set the product code or internal number of a product/item would be enforced to be unique
24	110	title	1	Delete old files
24	110	description	1	This task will delete files older than a certain time.
24	111	title	1	Updates Asset Transitions
24	111	description	1	This plug-in will update AssetTransitions when an asset status changes.
24	112	title	1	Remove Assets From FINISHED Orders
24	112	description	1	This plug-in will remove Asset owners when the linked order expires.
108	1	description	1	Member Of Group
24	113	description	1	A pluggable task of type InternalEventsTask to monitor when activeUntil changes of an order
24	113	title	1	Order Cancellation Task
47	35	description	1	A Reseller Order was created for the Root Entity during Invoice generation for a Child Entity.
115	1	description	1	PENDING
115	2	description	1	APPLY ERROR
52	25	description	1	Usage Pool Consumption
24	117	title	1	Calculate Agents' Commissions
24	117	description	1	This task schedules the process that calculates the Agents' Commissions.
23	25	description	1	Agent Commission Calculation Process.
24	118	title	1	Basic Agents' Commissions task
24	118	description	1	This task calculates the Agents' Commissions.
24	119	title	1	Generate payment commissions for agents.
24	119	description	1	This plug-in will create payment commissions when payments are linked an unlinked from invoices.
23	26	description	1	Files exchange with remote locations, upload and download
24	123	title	1	Trigger File Download/Upload
24	123	description	1	Triggers File Download/Upload against third party system
50	63	description	1	Should use JQGrid for tables
50	63	instruction	1	Set to '0' to use the common layout or set to '1' to use JQGrid on the site's tables
50	61	description	1	Agent Commission Type
50	61	instruction	1	Defines the default agents' commission type for the entity, one of: INVOICE, PAYMENT
24	124	title	1	User Credit Limitation notification task
24	124	description	1	A pluggable task of the type InternalEventsTask to monitor if users pre-paid balance is below a credit limitation 1 or 2 levels and send notifications.
52	26	description	1	Credit Limitation 1
52	27	description	1	Credit Limitation 2
50	64	description	1	Diameter Destination Realm
50	64	instruction	1	The realm to be charged. This can be used for routing Diameter messages, so should match a locally-configured realm.
50	65	description	1	Diameter Quota Threshold
50	65	instruction	1	When this number of seconds remains the call handling unit should request re-authorisation.
50	66	description	1	Diameter Session Grace Period
50	66	instruction	1	Number of seconds to wait before Diameter sessions are forcibly closed.
50	67	description	1	Diameter units multiplier/divisor
50	67	instruction	1	The units value received from Diameter is divided/multiplied by this factor to convert input seconds to other time units. Values < 1 set the multiplier to 1.
24	125	title	1	Change order status on order change apply
24	125	description	1	This plug-in will change the status of order during order change apply to selected in order change.
18	5	description	1	Subscription
59	101	description	1	Create agent
59	102	description	1	Edit agent
59	103	description	1	Delete agent
59	104	description	1	View agent details
59	93	description	3	Show payments and refunds menu
59	93	description	4	Show payments and refunds menu
52	18	description	1	Invoice Reminder
50	68	description	1	Account Lockout Time
50	68	instruction	1	Number of minutes a User's account will remain locked after the number of allowed retries (Preference 39) are exhausted.
47	37	description	1	A failed login attempt was made.
50	70	description	1	Expire Inactive Accounts After Days
50	70	instruction	1	Number of days after which a User's account will become inactive. This will disable the ability to login to jBilling for that user.
24	126	title	1	Inactive user account management plugin
24	126	description	1	This is a scheduled plugin that takes in user that has not been logged-in for number of days specified in preference 55 and update there status to Inactive.
100	13	description	1	Statement of User Activity within specified number of days
50	71	description	1	Forgot Password Expiration (hours)
50	71	instruction	1	Hours until the link for password change expires.
50	75	description	1	Should credentials be created by default
50	75	instruction	1	1 to have credentials created by default when the user is created. 0 (default) to require credential creation be requested upon creation.
52	21	description	1	Credentials creation
114	1	errorMessage	1	Failed login attempts can not be more than 6
114	2	errorMessage	1	Passwords must expire before 90 days
114	3	errorMessage	1	Inactive account checks must be done quicker than 90 days
47	38	description	1	User logged in successfully
47	39	description	1	User logged out successfully
47	40	description	1	User failed to log in due to incorrect username/password
114	4	errorMessage	1	Reservation duration should be between 0 and 600000
50	76	description	1	Default Asset Reservation Duration
50	76	instruction	1	Add Default Asset reservation minute here. It will work if product is asset enabled. (Must be greater than zero)
23	15	description	1	Mediation Reader
23	16	description	1	Mediation Processor
23	21	description	1	Mediation Error Handler
24	32	description	1	This is a reader for the mediation process. It reads records from a text file whose fields are separated by a character (or string).
24	33	title	1	Rules mediation processor
24	33	description	1	This is a rules-based plug-in (see chapter 7). It takes an event record from the mediation process and executes external rules to translate the record into billing meaningful data. This is at the core of the mediation component, see the ?Telecom Guide? document for more information.
24	34	description	1	This is a reader for the mediation process. It reads records from a text file whose fields have fixed positions,and the record has a fixed length.
24	44	title	1	JDBC Mediation Reader.
24	44	description	1	This is a reader for the mediation process. It reads records from a JDBC database source.
24	45	title	1	MySQL Mediation Reader.
24	45	description	1	This is a reader for the mediation process. It is an extension of the JDBC reader, allowing easy configuration of a MySQL database source.
24	79	title	1	Mediation Process Task
24	79	description	1	A scheduled task to execute the Mediation Process.
50	47	description	1	Last read mediation record id.
50	41	instruction	1	Set to '1' to allow the usage of the 'main subscription' flag for orders This flag is read only by the mediation process when determining where to place charges coming from external events.
50	47	instruction	1	ID of the last record read by the mediation process. This is used to determine what records are 'new' and need to be read.
59	95	description	1	Show mediation menu
4	12	description	1	Indian Rupee
4	13	description	1	Chinese Yuan
24	127	title	1	Basic Pricing Task
24	127	description	1	This is handles the pricing calculation (default implementation) based on usage of the item.
18	6	description	1	Plan
4	1	description	5	यूनाइटेड स्टेट का डॉलर
4	2	description	5	कैनेडियन डॉलर
4	3	description	5	यूरो
4	4	description	5	येन
4	5	description	5	पौंड स्टर्लिंग
4	6	description	5	वोन
4	7	description	5	स्विस फ्रैंक
4	8	description	5	स्वीडिश क्रोना
4	9	description	5	सिंगापुर का डॉलर
4	10	description	5	मलेशियाई रिंग्गित
4	11	description	5	ऑस्ट्रेलियाई डॉलर
4	12	description	5	भारतीय रुपया
4	13	description	5	चीनी युवान
6	1	description	5	माह
6	2	description	5	सप्ताह
6	3	description	5	दिन
6	4	description	5	साल
6	5	description	5	अर्ध मासिक
7	1	description	5	ईमेल
7	2	description	5	कागज़
7	3	description	5	ईमेल + पेपर
9	1	description	5	सक्रिय
9	2	description	5	बूढ़े दिवस 1
9	3	description	5	बूढ़े 4 दिन
9	4	description	5	बूढ़े दिन 5
9	5	description	5	बूढ़े दिवस 15
9	6	description	5	बूढ़े 16 दिन
9	7	description	5	बूढ़े 27 दिन
9	8	description	5	बूढ़े दिवस 30
9	9	description	5	बूढ़े डे 31
9	10	description	5	बूढ़े डे 32
9	11	description	5	बूढ़े 40 दिन
9	12	description	5	बूढ़े डे 45
9	13	description	5	बूढ़े डे 50
9	14	description	5	बूढ़े डे 55
9	15	description	5	बूढ़े डे 65
9	16	description	5	बूढ़े डे 90
9	17	description	5	बूढ़े डे 180
14	1	description	5	नींबू पानी - 1 दिन मासिक पास प्रति
14	2	description	5	नींबू पानी - आप सभी मासिक पी सकते हैं
14	3	description	5	कॉफी - प्रति दिन एक - मासिक
14	4	description	5	ज़हर आइवी रस (ठंड)
14	14	description	5	10% एल्फ छूट।
14	24	description	5	शुल्क रद्द
14	240	description	5	मुद्रा परीक्षण आइटम
14	250	description	5	नींबू पानी योजना
14	251	description	5	नींबू पानी योजना - सेटअप शुल्क
14	260	description	5	WS से एक आइटम
14	270	description	5	देर से भुगतान दंड शुल्क
14	1250	description	5	AM-1
14	2600	description	5	नींबू पानी - जेनेरिक
14	2601	description	5	नींबू पानी - योजना में शामिल
14	2602	description	5	नींबू पानी
14	2700	description	5	लंबी दूरी की योजना - निर्धारित दर
14	2701	description	5	लंबी दूरी की योजना B - निर्धारित दर
14	2702	description	5	लंबी दूरी की योजना - 1000 मिनट शामिल
14	2800	description	5	लंबी दूरी की कॉल
14	2801	description	5	लंबी दूरी की कॉल - शामिल
14	2900	description	5	लंबी दूरी की कॉल - जेनेरिक
14	3000	description	5	पागल ब्रायन की छूट योजना
14	3100	description	5	प्रतिशत लाइन परीक्षण योजना
14	3101	description	5	कूल योजना
14	320100	description	5	कॉल 1
17	1	description	5	एक बार
17	2	description	5	मासिक
17	3	description	5	मासिक
17	4	description	5	हर 3 महीने
17	5	description	5	सभी आदेश
17	6	description	5	मासिक
18	1	description	5	आइटम
18	2	description	5	टैक्स
18	3	description	5	दंड
18	4	description	5	छूट
18	5	description	5	अंशदान
18	6	description	5	योजना
19	1	description	5	पूर्व भुगतान
19	2	description	5	पद का भुगतान
20	1	description	5	सक्रिय
20	2	description	5	समाप्त
20	3	description	5	निलंबित
20	4	description	5	निलंबित (ऑटो)
20	400	description	5	कसौटी
23	1	description	5	आइटम प्रबंधन और व्यवस्था की लाइन की कुल गणना
23	2	description	5	बिलिंग प्रक्रिया: आदेश फिल्टर
23	3	description	5	बिलिंग प्रक्रिया: चालान फिल्टर
23	4	description	5	चालान प्रस्तुति
23	5	description	5	बिलिंग प्रक्रिया: आदेश की अवधि गणना
23	6	description	5	भुगतान गेटवे एकीकरण
23	7	description	5	सूचनाएं
23	8	description	5	भुगतान साधन चयन
23	9	description	5	अतिदेय चालान के लिए दंड
23	10	description	5	अलार्म एक भुगतान के प्रवेश द्वार के नीचे है जब
23	11	description	5	सदस्यता स्थिति मैनेजर
23	12	description	5	अतुल्यकालिक भुगतान प्रसंस्करण के लिए पैरामीटर
46	9	description	5	चालान रखरखाव
23	13	description	5	आदेश के लिए एक उत्पाद जोड़ें
23	14	description	5	उत्पाद के मूल्य निर्धारण
23	15	description	5	मध्यस्थता रीडर
23	16	description	5	मध्यस्थता प्रोसेसर
23	17	description	5	जेनेरिक आंतरिक घटनाओं श्रोता
23	19	description	5	प्री-पेड संतुलन / क्रेडिट सीमा के खिलाफ खरीद सत्यापन
23	20	description	5	बिलिंग प्रक्रिया: ग्राहक चयन
23	21	description	5	मध्यस्थता त्रुटि हैंडलर
23	22	description	5	अनुसूचित प्लग-इन
23	23	description	5	नियम जेनरेटर
23	24	description	5	अतिदेय चालान के साथ ग्राहकों के लिए बूढ़े
23	25	description	5	एजेंट कमीशन गणना प्रक्रिया।
23	26	description	5	"दूरस्थ स्थानों के साथ फ़ाइलों के आदान प्रदान, अपलोड और डाउनलोड"
24	1	description	5	"आइटम की कीमतों पर विचार, मात्रा के आदेश कुल और प्रत्येक पंक्ति के लिए कुल गणना करता है और कीमतों प्रतिशत कर रहे हैं या नहीं।"
24	1	title	5	डिफ़ॉल्ट आदेश योग
24	2	description	5	मूल्य वर्धित कर का प्रतिनिधित्व करने के लिए एक प्रतिशत शुल्क के साथ आदेश के लिए एक अतिरिक्त लाइन जोड़ता है।
24	2	title	5	वैट
24	3	description	5	चालान की नियत तारीख तय करता है कि एक बहुत ही सरल कार्यान्वयन। नियत तिथि सिर्फ चालान तिथि करने के लिए समय की अवधि को जोड़कर गणना की है।
24	3	title	5	बिल की देय तिथि
24	4	description	5	"इस काम के लिए प्रत्येक आदेश के लिए शामिल की अवधि पर विचार, नए चालान करने के लिए आदेश और चालान पर सभी लाइनों को कॉपी जाएगा, लेकिन समय में से नहीं अंशों। यह करों हैं कि लाइनों की नकल नहीं करेंगे। प्रत्येक पंक्ति की मात्रा और कुल अवधि की राशि से गुणा किया जाएगा। "
24	4	title	5	डिफ़ॉल्ट चालान रचना।
24	24	description	5	एसीएच वाणिज्य भुगतान के प्रवेश द्वार के साथ एकीकरण।
24	24	title	5	एसीएच वाणिज्य भुगतान प्रोसेसर
60	10	description	5	एक बिलिंग क्लर्क
24	5	description	5	"एक आदेश किसी भी बिलिंग प्रक्रिया के लिए एक चालान में शामिल किया जाना चाहिए कि अगर फैसला किया। यह सक्रिय बाद से / तक, आदि बिलिंग प्रक्रिया में समय अवधि, आदेश की अवधि, लेने के द्वारा किया जाता है"
24	5	title	5	स्टैंडर्ड आदेश फिल्टर
24	6	description	5	"हमेशा अतिदेय चालान एक नया चालान करने के लिए खत्म किया जाएगा जिसका अर्थ है कि सच देता है।"
24	6	title	5	स्टैंडर्ड चालान फ़िल्टर
24	7	description	5	"प्रारंभ और अंत की अवधि एक चालान में शामिल होने के लिए खरीदते हैं। जब तक यह आदि, / बिलिंग प्रक्रिया में समय अवधि, आदेश की अवधि, के बाद से सक्रिय लेने के द्वारा किया जाता है"
24	7	title	5	डिफ़ॉल्ट आदेश काल
24	8	description	5	Authorize.net भुगतान के प्रवेश द्वार के साथ एकीकरण।
24	8	title	5	Authorize.net भुगतान प्रोसेसर
24	9	description	5	एक ईमेल भेज कर एक उपयोगकर्ता सूचित करता है। यह पाठ और HTML ईमेल का समर्थन करता है
24	9	title	5	स्टैंडर्ड ईमेल अधिसूचना
24	10	description	5	"क्रेडिट कार्ड के लिए प्राथमिकता दी एक ग्राहक के लिए उपलब्ध एक भुगतान पद्धति की जानकारी पाता है। दूसरे शब्दों में, यह एक ग्राहक या आदेश में कहा कि एसीएच जानकारी के क्रेडिट कार वापस आ जाएगी।"
24	10	title	5	डिफ़ॉल्ट भुगतान की जानकारी
24	11	description	5	प्लग में उपयोगी केवल परीक्षण के लिए
24	11	title	5	साथी भुगतान के लिए प्लग में परीक्षण
24	12	description	5	एक चालान की एक PDF संस्करण उत्पन्न होगा।
24	12	title	5	पीडीएफ चालान अधिसूचना
24	31	title	5	नियम मूल्य निर्धारण
64	137	description	5	मेक्सिको
24	14	description	5	"एक और नए चालान में एक चालान पर ले जाने के लिए कभी नहीं jBilling बनाता है, जो हमेशा गलत देता है।"
24	14	title	5	कोई चालान पर ले
24	15	description	5	एक दंड आइटम के साथ एक नई व्यवस्था का निर्माण करेगा। आइटम कार्य करने के लिए एक पैरामीटर के रूप में लिया जाता है।
24	15	title	5	डिफ़ॉल्ट ब्याज कार्य
24	16	description	5	"BasicOrderFilterTask यह डिफ़ॉल्ट फिल्टर का उपयोग करके किया जाएगा से पहले लागू महीने की एक संख्या आदेश बनाने के लिए तारीखों को संशोधित करने, फैली हुई है।"
24	16	title	5	पूर्वानुमानित आदेश फिल्टर
24	17	description	5	"BasicOrderPeriodTask डिफ़ॉल्ट कार्य का उपयोग करके किया महीने की एक संख्या आईटीडी से पहले आदेश लागू करने के लिए तारीखों को संशोधित करने, फैली हुई है।"
24	17	title	5	आदेश अवधि की आशा।
24	19	description	5	भी भुगतान प्रसंस्करण के बाद कंपनी के लिए एक ईमेल भेजने के लिए मानक authorize.net भुगतान प्रोसेसर फैली हुई है।
24	19	title	5	ईमेल और प्रक्रिया authorize.net
24	20	description	5	एक भुगतान के प्रवेश द्वार के नीचे है, जब एक अलार्म के रूप में बिलिंग व्यवस्थापक को एक ईमेल भेजता है।
24	20	title	5	भुगतान गेटवे नीचे अलार्म
24	21	description	5	एक परीक्षण भुगतान प्रोसेसर कार्यान्वयन एक वास्तविक भुगतान गेटवे का उपयोग किए बिना jBillings कार्यों का परीक्षण करने में सक्षम हो।
24	21	title	5	टेस्ट भुगतान प्रोसेसर
24	22	description	5	एक ग्राहक एक विशिष्ट भुगतान गेटवे सौंपा जा सकता है। यह एक और प्लगइन के लिए प्रतिनिधियों को फिर वास्तविक भुगतान प्रसंस्करण प्रवेश द्वार की पहचान करने के लिए एक कस्टम संपर्क क्षेत्र की जांच करता है।
24	22	title	5	कस्टम फील्ड्स पर आधारित रूटर भुगतान प्रोसेसर
24	23	description	5	"भुगतान घटना इसका वर्तमान स्थिति और एक राज्य मशीन पर विचार, एक उपयोगकर्ता की सदस्यता स्थिति को प्रभावित करता है कि कैसे यह निर्धारित करता है।"
24	23	title	5	डिफ़ॉल्ट सदस्यता स्थिति मैनेजर
24	25	description	5	अतुल्यकालिक भुगतान प्रसंस्करण के लिए कोई पैरामीटर जोड़ नहीं है कि एक डमी कार्य। यह तयशुदा है।
24	25	title	5	स्टैंडर्ड अतुल्यकालिक मानकों को
24	26	description	5	अतुल्यकालिक भुगतान प्रसंस्करण भुगतान प्रोसेसर के प्रति एक प्रसंस्करण संदेश सेम है करने के लिए इस प्लग में मानकों को कहते हैं। यह रूटर भुगतान प्रोसेसर प्लग-इन के साथ संयोजन में उपयोग किया जाता है।
24	26	title	5	रूटर अतुल्यकालिक मानकों को
24	28	description	5	"यह एक आदेश में आइटम जोड़ता है। आइटम क्रम में पहले से ही है, यह केवल मात्रा अद्यतन करता है।"
24	28	title	5	मानक मद प्रबंधक
24	29	description	5	"यह ऐसा बुनियादी आइटम प्रबंधक (वास्तव में यह बुला) क्या करता होगा। एक नियम आधारित प्लग में है, लेकिन तब यह रूप में अच्छी तरह से बाहरी नियमों पर अमल करेंगे। ये बाहरी नियमों पूरा नियंत्रण है नया हो रही है कि आदेश को बदलने पर आइटम नहीं है। "
24	29	title	5	नियम मद प्रबंधक
24	30	description	5	"यह एक नियम आधारित प्लग में है। यह बाहरी नियमों के निष्पादन के लिए अनुमति देता है, एक आदेश लाइन के लिए कुल (आमतौर पर इस मात्रा से गुणा कीमत है) खरीदते हैं।"
24	30	title	5	नियम लाइन कुल
24	31	description	5	यह एक नियम आधारित प्लग में है। यह बाहरी नियमों को क्रियान्वित करने से एक आइटम के लिए एक कीमत देता है। तुम तो मूल्य निर्धारण के लिए बाह्य तर्क जोड़ सकते हैं। यह भी मध्यस्थता मूल्य निर्धारण डेटा तक पहुँच होने से मध्यस्थता की प्रक्रिया के साथ एकीकृत है।
14	2602	description	6	柠檬水
24	32	description	5	यह मध्यस्थता प्रक्रिया के लिए एक पाठक है। यह जिसका खेतों एक चरित्र (या स्ट्रिंग) से अलग होती है एक पाठ फ़ाइल से रिकॉर्ड पढ़ता है।
24	32	title	5	सेपरेटर फ़ाइल पाठक
24	33	description	5	"यह एक नियम आधारित प्लग में (अध्याय 7 देखें)। यह इस मध्यस्थता घटक के मूल में है। बिलिंग सार्थक डेटा में रिकॉर्ड अनुवाद करने के लिए बाहरी नियमों मध्यस्थता प्रक्रिया से एक घटना रिकॉर्ड लेता है और निष्पादित करता है, देखना है अधिक जानकारी के लिए? टेलीकॉम गाइड? दस्तावेज़। "
24	33	title	5	मध्यस्थता प्रोसेसर नियम
24	34	description	5	"यह मध्यस्थता प्रक्रिया के लिए एक पाठक है। यह जिसका क्षेत्रों पदों को तय की है एक पाठ फ़ाइल से रिकॉर्ड पढ़ता है, और रिकॉर्ड एक निश्चित लंबाई है।"
24	34	title	5	निश्चित लंबाई फ़ाइल पाठक
24	35	description	5	"यह वास्तव में मानक भुगतान जानकारी कार्य के रूप में एक ही है, फर्क सिर्फ इतना है क्रेडिट कार्ड समाप्त हो गई है, तो यह मान्य नहीं है। आप समाप्त हो गई है क्रेडिट कार्ड के साथ भुगतान प्रस्तुत करना चाहते हैं तभी इस प्लग-इन का प्रयोग करें।"
24	35	title	5	सत्यापन के बिना भुगतान के बारे में जानकारी
24	36	description	5	"इस प्लग में केवल परीक्षण प्रयोजनों के लिए प्रयोग किया जाता है। इसके बजाय एक ईमेल (या अन्य अचल अधिसूचना), यह बस emails_sent.txt नाम की एक फ़ाइल में भेजे जाने के लिए पाठ को संग्रहीत भेजने का।"
24	36	title	5	परीक्षण के लिए अधिसूचना कार्य
24	37	description	5	इस प्लगइन आंशिक आदेश की अवधि की गणना करने के लिए ध्यान में आदेशों के क्षेत्र चक्र शुरू होता है लेता है।
24	37	title	5	आदेश की अवधि के समर्थक रेटिंग के साथ कैलकुलेटर।
24	38	description	5	"एक आदेश से एक चालान बनाने, इस प्लग में होगा समर्थक दर सबसे छोटी बिल इकाई के रूप में लेने के एक दिन की अवधि के किसी भी अंश।"
24	38	title	5	समर्थक रेटिंग के साथ चालान रचना कार्य (अंश के रूप में दिन)
24	39	description	5	Intraanuity भुगतान के प्रवेश द्वार के साथ एकीकरण।
24	39	title	5	Intraanuity भुगतान के प्रवेश द्वार के लिए भुगतान की प्रक्रिया
24	40	description	5	इस प्लग में एक आदेश पहले से चालान कर दिया गया है कि एक अवधि के भीतर रद्द कर दिया है जब एक क्रेडिट प्रतिबिंबित करने के लिए एक नकारात्मक मूल्य के साथ एक नई व्यवस्था का निर्माण करेगा।
24	40	title	5	स्वत: रद्द क्रेडिट।
24	42	description	5	वास्तविक भुगतान प्रोसेसर तक पहुँचने से भुगतान रोकने के लिए इस्तेमाल किया। आमतौर पर प्रसंस्करण श्रृंखला में पहला भुगतान प्रोसेसर के रूप में विन्यस्त है।
24	42	title	5	ब्लैकलिस्ट फिल्टर भुगतान प्रोसेसर।
24	43	description	5	"उपयोगकर्ताओं का कारण बनता है और उनकी स्थिति को निलंबित कर दिया या अधिक हो जाता है जब उनके संबंधित विवरण (जैसे, क्रेडिट कार्ड नंबर, फोन नंबर, आदि) काली सूची में डाला जाना है।"
24	43	title	5	ब्लैकलिस्ट यूजर को अपनी स्थिति को निलंबित कर दिया या अधिक हो जाता है।
24	44	description	5	यह मध्यस्थता प्रक्रिया के लिए एक पाठक है। यह एक JDBC डेटाबेस स्रोत से रिकॉर्ड पढ़ता है।
24	44	title	5	जेडीबीसी मध्यस्थता रीडर।
24	45	description	5	"यह मध्यस्थता प्रक्रिया के लिए एक पाठक है। यह एक डाटाबेस स्रोत के आसान विन्यास अनुमति देता है, जेडीबीसी पाठक का एक विस्तार है।"
24	45	title	5	MySQL के मध्यस्थता रीडर।
24	49	description	5	प्रतिनिधियों भुगतान की मुद्रा पर आधारित एक और प्लग-इन करने के वास्तविक भुगतान प्रसंस्करण।
24	49	title	5	मुद्रा रूटर भुगतान प्रोसेसर
24	51	description	5	इस फिल्टर एक सकारात्मक संतुलन के साथ ही चालान अगले चालान करने के लिए खत्म किया जा करने के लिए होगा।
24	51	title	5	पर ले जाने के लिए नकारात्मक चालान से बाहर फिल्टर।
24	52	description	5	यह उत्पन्न चालान प्रति एक लाइन के साथ एक फ़ाइल उत्पन्न होगा।
24	52	title	5	चालान निर्यातक करें।
24	53	description	5	एक आंतरिक घटना होता है जब यह नियमों का एक पैकेज से मुलाकात करेंगे।
24	53	title	5	एक घटना पर नियम फोन करने वाले।
24	54	description	5	यह (प्री-पेड या क्रेडिट सीमा) को प्रभावित करने की घटनाओं संतुलन होता है जब एक ग्राहक के गतिशील संतुलन को अद्यतन करेगा।
24	54	title	5	गतिशील संतुलन प्रबंधक
24	55	title	5	ग्राहक संतुलन के आधार पर शेष राशि सत्यापनकर्ता।
24	56	title	5	नियमों के आधार पर शेष राशि सत्यापनकर्ता।
24	57	description	5	भुगतान गेटवे भुगतान प्रोसेसर के साथ एकीकरण।
24	57	title	5	भुगतान गेटवे के लिए भुगतान प्रोसेसर है।
24	58	description	5	"बल्कि jBilling डीबी से भुगतान के प्रवेश द्वार में क्रेडिट कार्ड की जानकारी, बचाता है।"
24	58	title	5	क्रेडिट कार्ड बाह्य जमा हो जाती है।
24	59	title	5	नियम मद प्रबंधक 2
24	60	title	5	नियम लाइन कुल - 2
24	61	description	5	यह एक नियम आधारित प्लग में jBilling 2.2.x. की मध्यस्थता के मॉड्यूल के साथ संगत यह बाहरी नियमों को क्रियान्वित करने से एक आइटम के लिए एक कीमत देता है। तुम तो मूल्य निर्धारण के लिए बाह्य तर्क जोड़ सकते हैं। यह भी मध्यस्थता मूल्य निर्धारण डेटा तक पहुँच होने से मध्यस्थता की प्रक्रिया के साथ एकीकृत है।
24	61	title	5	नियम मूल्य निर्धारण 2
24	63	description	5	एक नकली प्लग में बाहर से संग्रहीत किया जाएगा कि भुगतान का परीक्षण करने के लिए।
24	63	title	5	बाह्य भंडारण के लिए टेस्ट भुगतान प्रोसेसर।
52	21	description	5	साख सृजन
52	22	description	5	भुगतान में प्रवेश किया
24	64	description	5	भुगतान प्रोसेसर प्लग में आरबीएस WorldPay के साथ एकीकृत करने के लिए
24	64	title	5	WorldPay एकीकरण
24	65	description	5	"भुगतान प्रोसेसर प्लग में आरबीएस WorldPay के साथ एकीकृत करने के लिए। यह प्रवेश द्वार में क्रेडिट कार्ड की जानकारी (संख्या, आदि) संग्रहीत करता है।"
24	65	title	5	बाह्य भंडारण के साथ WorldPay एकीकरण
24	66	description	5	"एक ग्राहक का संतुलन नज़र रखता है और एक सीमा पर पहुंचने पर, यह एक वास्तविक समय भुगतान अनुरोध"
24	66	title	5	ऑटो पुनर्भरण
24	67	description	5	BeanStream भुगतान के प्रवेश द्वार के साथ एकीकरण के लिए भुगतान प्रोसेसर
24	67	title	5	BeanStream गेटवे एकीकरण
24	68	description	5	बाबा भुगतान के प्रवेश द्वार के साथ एकीकरण के लिए भुगतान प्रोसेसर
24	68	title	5	बाबा भुगतान गेटवे एकीकरण
24	69	description	5	बिलिंग प्रक्रिया का मूल्यांकन करने के लिए जो उपयोगकर्ताओं का चयन करने के लिए चलाता है जब कहा जाता है। यह बुनियादी कार्यान्वयन बस निलंबित (या बुरा) की स्थिति में नहीं है कि हर उपयोगकर्ता रिटर्न
24	69	title	5	स्टैंडर्ड बिलिंग प्रक्रिया उपयोगकर्ताओं फिल्टर
24	70	description	5	बिलिंग प्रक्रिया का मूल्यांकन करने के लिए जो उपयोगकर्ताओं का चयन करने के लिए चलाता है जब कहा जाता है। यह केवल पहले बिलिंग प्रक्रिया की तुलना में एक अगले चालान तिथि है कि आदेश के साथ उपयोगकर्ताओं के लिए देता है।
24	70	title	5	चयनात्मक बिलिंग प्रक्रिया उपयोगकर्ताओं फिल्टर
24	71	description	5	त्रुटियों के साथ इस घटना को रिकॉर्ड एक फाइल करने से बच रहे हैं
24	73	description	5	त्रुटियों के साथ इस घटना को रिकॉर्ड एक डेटाबेस तालिका करने से बच रहे हैं
24	75	description	5	के रूप में अच्छी तरह से पेपैल में एक भुगतान के प्रवेश द्वार और दुकानों क्रेडिट कार्ड की जानकारी के रूप में पेपैल के लिए भुगतान को सौंपी
24	75	title	5	बाह्य भंडारण के साथ पेपैल एकीकरण
24	76	description	5	के रूप में अच्छी तरह से authorize.net में एक भुगतान के प्रवेश द्वार और दुकानों क्रेडिट कार्ड की जानकारी के रूप में authorize.net को भुगतान को सौंपी
24	76	title	5	बाह्य भंडारण के साथ Authorize.net एकीकरण
24	77	description	5	प्रतिनिधियों भुगतान के भुगतान विधि पर आधारित एक और प्लग-इन करने के वास्तविक भुगतान प्रसंस्करण।
24	77	title	5	भुगतान विधि रूटर भुगतान प्रोसेसर
24	78	description	5	गतिशील रूप से एक वेग टेम्पलेट के आधार पर नियमों उत्पन्न करता है।
24	78	title	5	गतिशील नियमों जनरेटर
24	79	description	5	एक निर्धारित कार्य मध्यस्थता प्रक्रिया निष्पादित करने के लिए।
24	79	title	5	मध्यस्थता प्रक्रिया टास्क
24	80	description	5	एक निर्धारित कार्य बिलिंग प्रक्रिया निष्पादित करने के लिए।
24	80	title	5	बिलिंग प्रक्रिया टास्क
24	87	description	5	युग के खाते से अपेक्षित है कि दिनों की संख्या के आधार पर एक उपयोगकर्ता।
24	87	title	5	बेसिक उम्र बढ़ने
24	88	description	5	एक निर्धारित कार्य बूढ़े प्रक्रिया निष्पादित करने के लिए।
24	88	title	5	बूढ़े प्रक्रिया कार्य
24	89	description	5	युग के खाते से अपेक्षित है कि (छुट्टियों को छोड़कर) कार्यदिवसों की संख्या के आधार पर एक उपयोगकर्ता।
24	89	title	5	दिन के कारोबार उम्र बढ़ने
24	90	description	5	साथी के देश कोड मिलान किया जाता है तो प्रकार SimpleTaxCompositionTask की एक pluggable कार्य चालान करने के लिए टैक्स मद लागू करने के लिए।
24	90	title	5	देश कर चालान रचना टास्क
52	23	description	5	भुगतान (वापसी)
24	91	description	5	प्रकार AbstractChargeTask की एक pluggable काम के लिए एक विन्यास दिनों की अवधि से परे एक नियत तारीख होने के एक चालान की सजा पर लागू करने के लिए।
24	91	title	5	भुगतान की शर्तें जुर्माना टास्क
24	95	description	5	प्रकार भुगतान की एक प्लगेबल कार्य जानकारी टास्क कि पहले की जाँच के पसंदीदा विधि के लिए कोई डाटा नहीं है, तो यह विकल्प भुगतान के तरीके के लिए खोज से पसंदीदा भुगतान विधि
24	95	title	5	वैकल्पिक भुगतान जानकारी टास्क
24	97	description	5	यह कार्य एक अतिदेय चालान पर एक% -age या एक निश्चित राशि की सजा को लागू करने के लिए जिम्मेदार है। यह बिलिंग प्रक्रिया के आदेश एकत्र करता है बस से पहले इस कार्रवाई करता है, क्योंकि यह कार्य शक्तिशाली है।
24	97	title	5	Overude चालान पर जुर्माना टास्क
24	101	description	5	आंतरिक घटना हुई जब घटना आधार पर कस्टम अधिसूचना कार्य सूचना कस्टम सूचना संदेश लेता है और करता है
24	101	title	5	घटना आधार पर कस्टम अधिसूचना कार्य
24	102	description	5	यह एक नया संपर्क बनाया जाता है जब एक दूरस्थ वेब सेवा का आह्वान एक उदाहरण है कि प्लग में है।
24	102	title	5	उदाहरण वेब सेवा प्लगइन
24	105	description	5	इस प्लगइन Suretax इंजन परामर्श करके चालान करने के लिए कर लाइनों कहते हैं।
24	105	title	5	Suretax प्लगइन
24	107	description	5	इस प्लग में 0 के लिए एक नकारात्मक चालान के संतुलन और कुल की स्थापना की और शेष राशि के लिए एक क्रेडिट भुगतान पैदा करेगा।
24	107	title	5	नकारात्मक चालान पर क्रेडिट
46	7	description	5	आदेश रखरखाव
46	8	description	5	क्रेडिट कार्ड रखरखाव
24	108	description	5	उपयोगकर्ताओं को पूर्व-भुगतान संतुलन के लिए एक सीमा के स्तर से नीचे है और सूचनाएं भेज अगर प्रकार InternalEventsTask की एक pluggable कार्य की निगरानी के लिए।
24	108	title	5	उपयोगकर्ता शेष सीमा अधिसूचना कार्य
24	109	description	5	इस प्लग में प्रत्येक स्थिति के लिए भेजा जाना चाहिए कि उपयोगकर्ता स्थिति (उम्र बढ़ने कदम) और सूचनाओं के बीच मानचित्रण प्रदान करता है
24	109	title	5	उम्र बढ़ने के निर्देशों के अनुसार कस्टम उपयोगकर्ता सूचनाएं
24	110	description	5	इस काम के लिए एक निश्चित समय से फाइलों में पुराने को हटाना होगा।
24	110	title	5	पुरानी फाइलों को नष्ट
24	111	description	5	इस प्लग में जब एक परिसंपत्ति स्थिति परिवर्तन AssetTransitions अद्यतन करेगा।
24	111	title	5	अपडेट एसेट बदलाव
24	112	description	5	से जुड़े आदेश को समाप्त हो रहा है, जब इस प्लग में संपत्ति मालिकों को हटा देगा।
24	112	title	5	समाप्त आदेश से संपत्ति को निकालें
24	113	description	5	प्रकार InternalEventsTask की एक pluggable कार्य की निगरानी के लिए जब एक आदेश के activeUntil परिवर्तन
24	113	title	5	आदेश रद्द टास्क
24	117	description	5	इस कार्य के कार्यक्रम एजेंट कमीशन की गणना करता है कि प्रक्रिया।
24	117	title	5	एजेंट कमीशन की गणना
24	118	description	5	यह कार्य एजेंट कमीशन की गणना करता है।
24	118	title	5	बेसिक एजेंट कमीशन कार्य
24	119	description	5	भुगतान चालान से एक लिंक रद्द जुड़े हुए हैं जब इस प्लग में भुगतान आयोगों पैदा करेगा।
24	119	title	5	एजेंटों के लिए भुगतान आयोगों उत्पन्न करता है।
24	123	description	5	तीसरे पक्ष व्यवस्था के खिलाफ फाइल डाउनलोड / अपलोड ट्रिगर
24	123	title	5	उत्प्रेरक फ़ाइल डाउनलोड / अपलोड
24	124	description	5	प्रकार InternalEventsTask की एक pluggable कार्य उपयोगकर्ताओं को पूर्व-भुगतान संतुलन के लिए एक क्रेडिट सीमा से नीचे है, तो 1 या 2 के स्तर की निगरानी और सूचना भेजने के लिए।
24	124	title	5	उपयोगकर्ता क्रेडिट सीमा अधिसूचना कार्य
60	10	title	5	क्लर्क
24	125	description	5	आदेश परिवर्तन के दौरान व्यवस्था की स्थिति बदल जाएगा इस प्लग में आदेश परिवर्तन में चयनित करने के लिए लागू होते हैं।
24	125	title	5	लागू आदेश परिवर्तन पर आदेश की स्थिति बदलें
24	126	description	5	यह वरीयता 55 में निर्दिष्ट दिनों की संख्या के लिए लॉग-इन और निष्क्रिय करने के लिए वहाँ की स्थिति को अद्यतन नहीं किया गया है कि उपयोगकर्ता में लेता है कि एक अनुसूचित प्लगइन है।
24	126	title	5	निष्क्रिय उपयोगकर्ता खाता प्रबंधन प्लगइन
24	127	description	5	इस मद के उपयोग के आधार पर मूल्य निर्धारण गणना (डिफ़ॉल्ट कार्यान्वयन) संभालती है।
24	127	title	5	बेसिक मूल्य निर्धारण टास्क
28	2	description	5	मुख्य
28	3	description	5	मुख्य
28	4	description	5	अतिरिक्त संपर्क
35	1	description	5	चेक
35	2	description	5	वीज़ा
35	3	description	5	मास्टर कार्ड
35	4	description	5	एमेक्स
35	5	description	5	एसीएच
35	6	description	5	डिस्कवर
35	7	description	5	डिनर
35	8	description	5	पेपैल
35	9	description	5	पेमेंट गेटवे कुंजी
35	15	description	5	श्रेय
41	1	description	5	सफल
41	2	description	5	विफल
41	3	description	5	अनुपलब्ध प्रोसेसर
41	4	description	5	घुसा
46	1	description	5	बिलिंग प्रक्रिया
46	2	description	5	उपयोगकर्ता रखरखाव
46	3	description	5	मद रखरखाव
46	4	description	5	आइटम प्रकार रखरखाव
46	5	description	5	मद उपयोगकर्ता कीमत रखरखाव
46	6	description	5	प्रमोशन रखरखाव
47	1	description	5	एक प्रीपेड आदेश बिलिंग प्रक्रिया की तारीख से पहले unbilled समय है
47	2	description	5	आदेश की प्रक्रिया की तारीख में कोई सक्रिय समय दिया है।
47	3	description	5	कम से कम एक पूरी अवधि के बिल हो गया है।
47	4	description	5	पहले से ही आज की तारीख के लिए बिल भेजा।
47	5	description	5	इस आदेश के अंतिम प्रक्रिया में बहिष्कार के लिए चिह्नित किया जा सकता था।
47	6	description	5	प्री-पेड आदेश इसकी समाप्ति के बाद की प्रक्रिया की जा रही है।
47	7	description	5	हटाए रूप में एक पंक्ति के रूप में चिह्नित किया गया था।
47	8	description	5	एक उपयोगकर्ता पासवर्ड बदल दिया गया था।
47	9	description	5	एक पंक्ति अद्यतन किया गया था।
47	10	description	5	"एक बिलिंग प्रक्रिया चल रही है, लेकिन एक समीक्षा अननुमोदित पाया जाता है।"
47	11	description	5	"एक बिलिंग प्रक्रिया चल रहा है, समीक्षा की आवश्यकता है लेकिन मौजूद नहीं है।"
47	12	description	5	एक उपयोगकर्ता स्थिति बदल गया था।
47	13	description	5	एक आदेश स्थिति बदल गया था।
47	14	description	5	"एक उपयोगकर्ता आयु वर्ग किया जा सकता था, लेकिन के लिए कॉन्फ़िगर कोई और अधिक कदम उठाए हैं।"
47	15	description	5	"एक साथी के लिए तैयार एक भुगतान, लेकिन कोई भुगतान साधन है।"
47	16	description	5	मैन्युअल एक चालान करने के लिए लागू किया गया के रूप में एक खरीद आदेश।
47	17	description	5	आदेश पंक्ति अद्यतन किया गया है
47	18	description	5	आदेश अगले बिलिंग तारीख बदल दिया गया है
47	19	description	5	अंतिम API कॉल उपयोगकर्ता सदस्यता स्थिति बदलाव लाने के लिए
47	20	description	5	प्रयोक्ता सदस्यता स्थिति बदल गई है
47	21	description	5	उपयोगकर्ता खाता अब बंद कर दिया है
47	22	description	5	आदेश मुख्य सदस्यता झंडा बदल गया था
52	24	description	5	सीमा से नीचे शेष
52	25	description	5	उपयोग पूल की खपत
47	24	description	5	एक वैध भुगतान पद्धति नहीं मिला था। भुगतान अनुरोध को रद्द कर दिया गया था
47	25	description	5	एक नई पंक्ति बनाया गया है
47	26	description	5	"एक चालान के आदेश को रद्द कर दिया गया था, एक क्रेडिट आदेश बनाया गया था"
47	27	description	5	एक यूजर आईडी काला सूची में जोड़ा गया था
47	28	description	5	एक यूजर आईडी काली सूची से हटा दिया गया था
47	32	description	5	प्रयोक्ता सदस्यता स्थिति नहीं बदला है
47	33	description	5	एक उपयोगकर्ता के गतिशील संतुलन बदल गया है
47	34	description	5	बच्चे झंडा बदल गया है, तो चालान
47	35	description	5	एक पुनर्विक्रेता आदेश एक बच्चे की इकाई के लिए चालान पीढ़ी के दौरान रूट इकाई के लिए बनाया गया था।
47	37	description	5	एक असफल लॉगिन प्रयास किया गया था।
47	38	description	5	प्रयोक्ता को सफलतापूर्वक में लॉग इन
47	39	description	5	प्रयोक्ता को सफलतापूर्वक लॉग आउट
47	40	description	5	उपयोगकर्ता की वजह से गलत नाम / पासवर्ड में लॉग इन करने में विफल रहा है
50	4	description	5	मुहलत
50	4	instruction	5	एक अरसे से चालान के साथ एक ग्राहक की उम्र बढ़ने से पहले के दिनों में ग्रेस अवधि।
50	13	description	5	कागज चालान की स्व वितरण
50	13	instruction	5	बिलिंग कंपनी के रूप में ई-मेल के चालान करने के लिए 1 के लिए निर्धारित किया है। JBilling के रूप में चालान देने के लिए 0।
50	14	description	5	चालान में ग्राहक नोट शामिल हैं
50	14	instruction	5	", चालान में नोटों को दिखाने के लिए 1 सेट 0 निष्क्रिय करने के लिए।"
50	15	description	5	आदेश अधिसूचना के लिए समाप्ति से पहले के दिनों
59	50	description	5	उत्पाद श्रेणी बनाएं
50	15	instruction	5	दिनों की तारीख जब तक सक्रिय के आदेश 1 सूचना भेजने के लिए पहले। निष्क्रिय करने के लिए खाली छोड़ दें।
50	16	description	5	आदेश अधिसूचना 2 के लिए समाप्ति से पहले के दिनों
50	16	instruction	5	दिनों की तारीख जब तक सक्रिय के आदेश 2 सूचना भेजने के लिए पहले। निष्क्रिय करने के लिए खाली छोड़ दें।
50	17	description	5	आदेश अधिसूचना 3 के लिए समाप्ति से पहले के दिनों
50	17	instruction	5	दिनों की तारीख जब तक सक्रिय के आदेश 3 सूचना भेजने के लिए पहले। निष्क्रिय करने के लिए खाली छोड़ दें।
50	18	description	5	चालान नंबर उपसर्ग
50	18	instruction	5	उत्पन्न चालान सार्वजनिक नंबरों के लिए उपसर्ग मूल्य।
50	19	description	5	अगले चालान संख्या
50	19	instruction	5	उत्पन्न चालान सार्वजनिक नंबरों के लिए वर्तमान मूल्य। नए चालान इस मूल्य बढ़ाने के द्वारा एक सार्वजनिक नंबर आवंटित किया जाएगा।
50	20	description	5	मैनुअल चालान विलोपन
50	20	instruction	5	"चालान, हटाए जाने की अनुमति देने के लिए 1 सेट 0 निष्क्रिय करने के लिए।"
50	21	description	5	चालान अनुस्मारक का उपयोग
50	21	instruction	5	", चालान अनुस्मारक सूचनाएं अनुमति देने के लिए 1 सेट 0 निष्क्रिय करने के लिए।"
50	22	description	5	पहले याद दिलाने के लिए चालान पीढ़ी के बाद के दिनों की संख्या
50	23	description	5	अगले याद दिलाने के लिए दिनों की संख्या
50	24	description	5	डेटा Fattura ललित Mese
50	24	instruction	5	", सक्षम करने के लिए एक सेट 0 निष्क्रिय करने के लिए।"
50	25	description	5	अतिदेय दंड (ब्याज) का प्रयोग करें।
50	25	instruction	5	", अतिदेय भुगतान पर ब्याज की गणना करने के लिए बिलिंग प्रक्रिया को सक्षम करने के लिए एक सेट 0 निष्क्रिय करने के लिए। ब्याज की गणना चयनित दंड प्लग द्वारा नियंत्रित किया जाता है।"
50	27	description	5	आदेश प्रत्याशा का प्रयोग करें।
52	26	description	5	क्रेडिट सीमा 1
52	27	description	5	क्रेडिट सीमा 2
50	27	instruction	5	"OrderFilterAnticipateTask" "का उपयोग करने के लिए 1 के लिए सेट" "निष्क्रिय करने के लिए अग्रिम में 0 महीने की एक संख्या चालान करने के लिए। प्लग-इि अलग से विन्यस्त किया जाना चाहिए।"
50	28	description	5	पेपैल खाते।
50	28	instruction	5	पेपैल खाते का नाम।
50	29	description	5	पेपैल बटन यूआरएल।
50	29	instruction	5	"वे एक भुगतान कर रहे हैं जब पेपैल बटन के ग्राफिक रहता है जहां एक URL। बटन ग्राहकों को प्रदर्शित किया जाता है। डिफ़ॉल्ट आमतौर पर एक और भाषा की जरूरत है, को छोड़कर जब सबसे अच्छा विकल्प है।"
50	30	description	5	HTTP उम्र बढ़ने कॉलबैक के लिए URL।
50	30	instruction	5	उम्र बढ़ने की प्रक्रिया के लिए एक उपयोगकर्ता की स्थिति में परिवर्तन जब HTTP कॉलबैक के लिए URL आह्वान करने के लिए।
50	31	description	5	निरंतर चालान तिथियाँ का प्रयोग करें।
50	31	instruction	5	। "खाली चूक यह वरीयता एक तारीख हो गया है (प्रारूप YYYY-MM-DD में उदाहरण:। 2000/01/31), प्रणाली अपने सभी चालान एक वृद्धिशील रास्ते में उनकी तारीखों को यकीन है कि कर देगा किसी भी चालान के साथ। एक बड़ा आईडी इसके अलावा, इस वरीयता का उपयोग करें। दूसरे शब्दों में, एक नया चालान एक मौजूदा (पुराने) चालान से पहले के एक तारीख नहीं कर सकते हैं। एक बड़ा (या बराबर) की तारीख की तारीख के साथ एक स्ट्रिंग के रूप में इसे स्थापित करेगा शुरू करने के लिए है। यह वरीयता "रिक्त है, तो उपयोग नहीं किया जाएगा
50	32	description	5	ईमेल सूचना के लिए पीडीएफ चालान संलग्न।
50	32	instruction	5	1 के लिए निर्धारित सभी चालान सूचना ई-मेल करने के लिए चालान की एक PDF संस्करण संलग्न करने के लिए। निष्क्रिय करने के लिए 0।
50	33	description	5	चालान के अनुसार एक आदेश के लिए बाध्य करें।
50	33	instruction	5	"" अलग चालान में शामिल हैं "दिखाने के लिए एक के लिए सेट" "एक आदेश पर झंडा। 0 निष्क्रिय करने के लिए।"
50	35	description	5	चालान लाइनों को आदेश क्रमांक जोड़ें।
50	35	instruction	5	"जिसके परिणामस्वरूप चालान पंक्ति का विवरण पाठ में आदेश की आईडी शामिल करने के लिए 1 के लिए सेट करें। निष्क्रिय करने के लिए 0। यह आसानी से जो सटीक आदेश को ट्रैक करने में मदद कर सकते हैं कई विचार है कि एक चालान में एक लाइन के लिए जिम्मेदार है आदेश के एक भी चालान में शामिल किया जा सकता है। "
50	36	description	5	ग्राहकों को खुद के संपर्क जानकारी को संपादित करने की अनुमति दें।
50	36	instruction	5	ग्राहकों को अपने स्वयं संपर्क जानकारी को संपादित करने की अनुमति देने के लिए 1 के लिए निर्धारित किया है। निष्क्रिय करने के लिए 0।
50	38	description	5	लिंक ग्राहक ग्राहक का दर्जा के लिए उम्र बढ़ने।
50	38	instruction	5	एक उपयोगकर्ता जब उपयोगकर्ता उम्र की सदस्यता स्थिति बदलने के लिए एक के लिए निर्धारित किया है। निष्क्रिय करने के लिए 0।
50	39	description	5	लॉक-आउट उपयोगकर्ता विफल लॉगिन प्रयास के बाद।
50	39	instruction	5	"प्रयासों की संख्या को उपयोगकर्ता खाते पर ताला लगा होने से पहले अनुमति देने के लिए। एक बंद उपयोगकर्ता खाते इस लॉकिंग सुविधा को सक्षम करने के लिए वरीयता 68. में निर्दिष्ट मिनट की राशि के लिए बंद कर दिया जाएगा, एक गैर शून्य मान के लिए बहुत जरूरी पसंद 68 की स्थापना।"
50	40	description	5	दिनों के बाद उपयोगकर्ता पासवर्ड समाप्त।
50	40	instruction	5	"शून्य से अधिक है, यह एक पासवर्ड मान्य है उन दिनों की संख्या का प्रतिनिधित्व करता है। उन दिनों के बाद पासवर्ड समाप्त हो गई है और उपयोगकर्ता इसे बदलने के लिए मजबूर किया जाता है।"
50	41	description	5	मुख्य सदस्यता के आदेश का प्रयोग करें।
59	10	description	5	ग्राहक बनाएं
59	14	description	6	黑名单客户
50	41	instruction	5	बाहरी घटनाओं से आने वाले आरोपों के लिए जगह है, जहां का निर्धारण करते हैं तो यह झंडा केवल मध्यस्थता प्रक्रिया द्वारा पढ़ा जाता है आदेश के लिए मुख्य सदस्यता ध्वज के उपयोग को अनुमति देने के लिए 1 के लिए निर्धारित किया है।
50	42	description	5	समानुपातिक का प्रयोग करें।
50	42	instruction	5	एक अवधि के भागों चालान करने के लिए समानुपातिक का उपयोग करने की अनुमति के लिए 1 के लिए निर्धारित किया है। एक आदेश के चक्र विशेषता से पता चलता है। इस सुविधा को पूरी तरह से कार्यशील होने के लिए आप इसी प्लग-इन्स विन्यस्त करने की जरूरत है कि ध्यान दें।
50	43	description	5	भुगतान काला सूची का प्रयोग करें।
50	43	instruction	5	"भुगतान ब्लैकलिस्ट सुविधा का उपयोग किया जाता है, तो इस PaymentFilterTask प्लग-इन के विन्यास की आईडी को तैयार है। दस्तावेज की ब्लैकलिस्ट अनुभाग देखें।"
50	44	description	5	नकारात्मक भुगतान की अनुमति दें।
50	44	instruction	5	1 के लिए सेट नकारात्मक भुगतान की अनुमति है। निष्क्रिय करने के लिए 0
50	45	description	5	विलंब नकारात्मक चालान भुगतान।
50	45	instruction	5	"अगले चालान को खत्म किया जाना शेष है, जिससे 1 नकारात्मक चालान राशि के भुगतान में देरी करने के लिए सेट करें। उन्हें स्थानांतरित अन्य चालान से नकारात्मक शेष राशि पड़ा है कि चालान तुरंत एक नकारात्मक भुगतान (क्रेडिट) बनाने के लिए अनुमति दी जाती है की जरूरत है।  0 निष्क्रिय करने के लिए। पसंद 44 व 46 को आम तौर पर भी सक्षम हैं। "
50	46	description	5	आदेश के बिना चालान की अनुमति दें।
59	51	description	5	संपादित करें उत्पाद की श्रेणी
50	46	instruction	5	1 के लिए सेट नकारात्मक संतुलन के साथ चालान अपनी शेष राशि हमेशा जगह लेने के लिए क्रेडिट के लिए एक नया चालान करने के लिए खत्म किया जाएगा, जिससे कि किसी भी आदेश की रचना नहीं है कि एक नया चालान उत्पन्न करने के लिए अनुमति देने के लिए। निष्क्रिय करने के लिए 0। पसंद 44 व 45 को आम तौर पर भी सक्षम हैं।
50	47	description	5	पिछले पढ़ा मध्यस्थता रिकॉर्ड आईडी।
50	47	instruction	5	मध्यस्थता प्रक्रिया के द्वारा पढ़ा पिछले रिकॉर्ड की आईडी। इस रिकॉर्ड के नए कर रहे हैं और पढ़ने की आवश्यकता क्या निर्धारित करने के लिए प्रयोग किया जाता है।
50	49	description	5	स्वत: ग्राहक रिचार्ज दहलीज।
50	49	instruction	5	स्वचालित भुगतान के लिए सीमा मूल्य। खाते की शेष राशि इस सीमा से नीचे गिर जाता है जब भी एक स्वचालित पुनर्भरण मूल्य सेट के साथ प्री-पेड यूजर्स एक स्वचालित भुगतान उत्पन्न होगा। आप AutoRechargeTask प्लग में इस सुविधा को पूरी तरह से कार्यशील होने के लिए विन्यस्त करने की जरूरत है कि ध्यान दें।
50	50	description	5	चालान दशमलव गोलाई।
50	50	instruction	5	दशमलव स्थानों की संख्या चालान पर दिखाया जा सकता है। 2 से चूक।
50	51	description	5	उम्र बढ़ने की अनदेखी करने के लिए, जिसके लिए न्यूनतम शेष
50	51	instruction	5	"सेट करते हैं उपयोगकर्ता बूढ़े या अवैतनिक चालान के लिए सूचनाएं प्राप्त करने के लिए जारी करने के लिए पर्याप्त संतुलन है यदि व्यापार एक चालान पर अतिदेय यदि अनदेखी करने के लिए तैयार है, न्यूनतम शेष है।, इस मूल्य का निर्धारण करेगा"
50	52	description	5	सभी अतिदेय अधिसूचना करने के लिए नवीनतम चालान संलग्न।
50	52	instruction	5	"अतिदेय अधिसूचना अतिदेय 1 2 और सूचना ई-मेल करने के लिए चालान संलग्न नहीं करते। इस वरीयता के साथ डिफ़ॉल्ट रूप से 3, नवीनतम चालान स्वचालित रूप से इस तरह की सूचनाओं को संलग्न किया जा सकता है।"
50	53	description	5	सेना के अनूठे ईमेल
59	11	description	5	संपादित ग्राहक
59	12	description	5	ग्राहक को हटाएँ
64	35	description	6	布隆迪
50	53	instruction	5	कंपनी में उपयोगकर्ताओं / ग्राहकों के बीच अनूठे ईमेल के लिए मजबूर करने के क्रम में 1 पर सेट। अन्यथा 0 करने के लिए सेट करें।
50	55	description	5	अनोखा उत्पाद कोड
50	55	instruction	5	"एक उत्पाद के उत्पाद कोड या आंतरिक नंबर निर्धारित करते हैं तो अनूठा उत्पाद कोड, / आइटम अद्वितीय होना लागू किया जाएगा अनुमति देता है"
50	61	description	5	एजेंट कमीशन के प्रकार
50	61	instruction	5	"इकाई के लिए डिफ़ॉल्ट एजेंट का कमीशन प्रकार परिभाषित करता है, में से एक: चालान, भुगतान"
50	63	description	5	टेबल के लिए JQGrid का उपयोग करना चाहिए
50	63	instruction	5	आम लेआउट का उपयोग करने के लिए 0 सेट या साइट की टेबल पर JQGrid का उपयोग करने के लिए 1 के लिए सेट
50	64	description	5	व्यास गंतव्य दायरे
50	64	instruction	5	"दायरे आरोप लगाए जाने की। यह व्यास संदेशों मार्ग के लिए इस्तेमाल किया जा सकता है, तो एक स्थानीय रूप से विन्यस्त दायरे से मेल खाना चाहिए।"
50	65	description	5	व्यास कोटा थ्रेसहोल्ड
50	65	instruction	5	सेकंड की इस संख्या को फिर से प्राधिकरण से अनुरोध करना चाहिए इकाई से निपटने के कॉल रहता है।
50	66	description	5	व्यास सत्र ग्रेस पीरियड
50	66	instruction	5	व्यास सत्र जबरन बंद हो जाती हैं पहले सेकंड की संख्या में इंतजार करने के लिए।
50	67	description	5	व्यास इकाइयों गुणक / भाजक
59	52	description	5	उत्पाद श्रेणी हटाएं
59	70	description	5	चालान मिटायें
59	71	description	5	चालान सूचना भेजें
59	72	description	5	देखें चालान विवरण
50	67	instruction	5	व्यास से प्राप्त इकाइयों मूल्य अन्य समय इकाइयों के लिए इनपुट सेकंड में परिवर्तित करने के लिए इस पहलू से गुणा / बांटा गया है। मूल्यों <1 1 के लिए गुणक निर्धारित किया है।
50	68	description	5	खाते तालाबंदी समय
50	68	instruction	5	एक उपयोगकर्ता के खाते अनुमति प्रयासों की संख्या (वरीयता 39) के बाद बंद कर दिया रहेगा मिनट की संख्या समाप्त हो रहे हैं।
50	70	description	5	निष्क्रिय खातों के दिनों के बाद समाप्त
50	70	instruction	5	दिनों की संख्या, जिसके बाद एक उपयोगकर्ता के खाते निष्क्रिय हो जाएगा। मतलब यह है कि उपयोगकर्ता के लिए jBilling के लिए लॉग इन करने की क्षमता को निष्क्रिय कर देगा।
50	71	description	5	पासवर्ड भूल गए समाप्ति (घंटे)
50	71	instruction	5	घंटे पासवर्ड बदलने के लिए लिंक को समाप्त हो रहा है जब तक।
50	75	description	5	साख डिफ़ॉल्ट रूप से बनाया जाना चाहिए
50	75	instruction	5	उपयोगकर्ता बनाया जाता है जब एक डिफ़ॉल्ट रूप से बनाया साख है। 0 (डिफ़ॉल्ट) क्रेडेंशियल सृजन निर्माण पर अनुरोध किया जा आवश्यकता होती है।
50	76	description	5	डिफ़ॉल्ट एसेट आरक्षण अवधि
50	76	instruction	5	यहाँ डिफ़ॉल्ट एसेट आरक्षण मिनट जोड़ें। उत्पाद परिसंपत्ति सक्षम है, तो यह काम करेगा। (शून्य से अधिक होना चाहिए)
52	1	description	5	चालान (ई-मेल)
52	2	description	5	प्रयोक्ता पुन: सक्रिय
52	3	description	5	अतिदेय उपयोगकर्ता
52	4	description	5	उपयोगकर्ता अतिदेय 2
52	5	description	5	उपयोगकर्ता अतिदेय 3
52	6	description	5	उपयोगकर्ता निलंबित
52	7	description	5	प्रयोक्ता 2 निलंबित
52	8	description	5	उपयोगकर्ता 3 निलंबित
52	9	description	5	प्रयोक्ता हटाए गए
52	12	description	5	चालान (कागज)
52	13	description	5	समय सीमा समाप्त करने के बारे में आदेश। स्टेप 1
52	14	description	5	समय सीमा समाप्त करने के बारे में आदेश। चरण 2
52	15	description	5	समय सीमा समाप्त करने के बारे में आदेश। चरण 3
52	16	description	5	भुगतान सफल)
52	17	description	5	भुगतान असफल हुआ)
52	18	description	5	चालान रिमाइंडर
52	19	description	5	अपडेट क्रेडिट कार्ड
52	20	description	5	पासवर्ड खो गया
59	13	description	5	ग्राहक का निरीक्षण
59	14	description	5	ब्लैकलिस्ट ग्राहक
59	15	description	5	देखें ग्राहक के विवरण
59	16	description	5	डाउनलोड ग्राहक सीएसवी
59	17	description	5	सभी ग्राहकों को देखें
59	18	description	5	देखें ग्राहक उप खातों
59	20	description	5	आदेश बनाएं
59	21	description	5	संपादित करें आदेश
59	22	description	5	आदेश को हटाने
59	23	description	5	आदेश के लिए चालान उत्पन्न
59	24	description	5	आदेश को विस्तार से देखें
59	25	description	5	डाउनलोड आदेश सीएसवी
59	26	description	5	संपादित लाइन कीमत
59	27	description	5	संपादित लाइन विवरण
59	28	description	5	सभी ग्राहकों को देखें
59	29	description	5	देखें ग्राहक उप खातों
59	30	description	5	भुगतान बनाएं
59	31	description	5	संपादित करें भुगतान
59	32	description	5	भुगतान मिटायें
59	33	description	5	चालान करने के लिए भुगतान लिंक
59	34	description	5	देखें भुगतान की जानकारी
59	35	description	5	डाउनलोड भुगतान सीएसवी
59	36	description	5	सभी ग्राहकों को देखें
59	37	description	5	देखें ग्राहक उप खातों
59	40	description	5	उत्पाद बनाएँ
59	41	description	5	संपादित उत्पाद
59	42	description	5	उत्पाद को हटाना
59	43	description	5	सारे उत्पाद विवरण
59	44	description	5	डाउनलोड उत्पाद सीएसवी
59	73	description	5	डाउनलोड चालान सीएसवी
59	74	description	5	सभी ग्राहकों को देखें
59	75	description	5	देखें ग्राहक उप खातों
59	80	description	5	/ अस्वीकृत समीक्षा को मंजूरी
59	90	description	5	दिखाएँ ग्राहक मेनू
59	91	description	5	दिखाएँ चालान मेनू
59	92	description	5	शो आदेश मेनू
59	93	description	5	दिखाएँ भुगतान और रिफंड मेनू
59	94	description	5	दिखाएँ बिलिंग मेनू
59	95	description	5	मध्यस्थता मेनू दिखाएँ
59	96	description	5	दिखाएँ मेनू की रिपोर्ट
59	97	description	5	दिखाएँ उत्पादों मेनू
59	99	description	5	शो विन्यास मेनू
59	100	description	5	दिखाएँ एजेंट मेनू
59	101	description	5	एजेंट बनाएं
59	102	description	5	संपादित एजेंट
59	103	description	5	एजेंट मिटायें
59	104	description	5	देखें एजेंट विवरण
59	110	description	5	उप-खाते स्विच करने के लिए
59	111	description	5	किसी भी उपयोगकर्ता स्विच करने के लिए
59	120	description	5	वेब सेवा एपीआई पहुँच
59	121	description	5	ग्राहक के संपादित बिलिंग चक्र
60	1	description	5	सभी अनुमतियों के साथ एक आंतरिक उपयोगकर्ता
60	1	title	5	आंतरिक
60	2	description	5	एक इकाई के सुपर उपयोगकर्ता
60	2	title	5	सुपर उपयोगकर्ता
60	3	description	5	एक बिलिंग क्लर्क
60	3	title	5	क्लर्क
60	4	description	5	ग्राहकों को लाना होगा कि एक एजेंट
60	4	title	5	एजेंट
60	5	description	5	उसकी / उसके खाते क्वेरी करेगा कि एक ग्राहक
60	5	title	5	ग्राहक
60	6	description	5	उसकी / उसके खाते क्वेरी करेगा कि एक ग्राहक
60	6	title	5	ग्राहक
60	7	description	5	एक इकाई के सुपर उपयोगकर्ता
60	7	title	5	सुपर उपयोगकर्ता
60	8	description	5	एक बिलिंग क्लर्क
60	8	title	5	क्लर्क
60	9	description	5	एक इकाई के सुपर उपयोगकर्ता
60	9	title	5	सुपर उपयोगकर्ता
60	11	description	5	उसकी / उसके खाते क्वेरी करेगा कि एक ग्राहक
60	11	title	5	ग्राहक
60	12	description	5	ग्राहकों को लाना होगा कि एक साथी
60	12	title	5	एजेंट
64	1	description	5	अफ़ग़ानिस्तान
64	2	description	5	अल्बानिया
64	3	description	5	एलजीरिया
64	4	description	5	अमेरिकन समोआ
64	5	description	5	अंडोरा
64	6	description	5	अंगोला
64	7	description	5	एंगुइला
64	8	description	5	अंटार्कटिका
64	9	description	5	अंतिगुया और बार्बूडा
64	10	description	5	अर्जेंटीना
64	11	description	5	आर्मीनिया
64	12	description	5	अरूबा
64	13	description	5	ऑस्ट्रेलिया
64	14	description	5	ऑस्ट्रिया
64	15	description	5	आज़रबाइजान
64	16	description	5	बहामा
64	17	description	5	बहरीन
64	18	description	5	बांग्लादेश
64	19	description	5	बारबाडोस
64	20	description	5	बेलोरूस
64	21	description	5	बेल्जियम
64	22	description	5	बेलीज
64	23	description	5	बेनिन
64	24	description	5	बरमूडा
64	25	description	5	भूटान
64	26	description	5	बोलीविया
64	27	description	5	बोस्निया और हर्जेगोविना
64	28	description	5	बोत्सवाना
64	29	description	5	बुवेत आइलैंड
64	30	description	5	ब्राज़िल
64	31	description	5	ब्रिटेन और भारतीय समुद्री क्षेत्र
64	32	description	5	ब्रुनेई
64	33	description	5	बुल्गारिया
64	34	description	5	बुर्किना फासो
64	35	description	5	बुस्र्न्दी
64	36	description	5	कंबोडिया
64	37	description	5	कैमरून
64	38	description	5	कनाडा
64	39	description	5	केप वर्दे
64	40	description	5	केमैन टापू
64	41	description	5	केंद्रीय अफ्रीकन गणराज्य
64	42	description	5	काग़ज़ का टुकड़ा
64	43	description	5	चिली
64	44	description	5	चीन
64	45	description	5	क्रिसमस द्वीप
64	46	description	5	कोकोस (कीलिंग) द्वीप
64	47	description	5	कोलम्बिया
64	48	description	5	कोमोरोस
64	49	description	5	कांगो
64	50	description	5	कुक द्वीपसमूह
64	51	description	5	कोस्टा रिका
64	52	description	5	Cï¿½1ï¿½7te डी आइवर
64	53	description	5	क्रोएशिया (Hrvatska)
64	54	description	5	क्यूबा
64	55	description	5	साइप्रस
64	56	description	5	चेक गणतंत्र
64	57	description	5	कांगो (डीआरसी)
64	58	description	5	डेनमार्क
64	59	description	5	जिबूती
64	60	description	5	डोमिनिका
64	61	description	5	डोमिनिकन गणराज्य
64	62	description	5	पूर्वी तिमोर
64	63	description	5	इक्वेडोर
64	64	description	5	मिस्र
64	65	description	5	एल साल्वाडोर
64	66	description	5	भूमध्यवर्ती गिनी
64	67	description	5	इरिट्रिया
64	68	description	5	एस्तोनिया
64	69	description	5	इथियोपिया
64	70	description	5	फ़ॉकलैंड द्वीप (इस्लास माल्विनास)
64	71	description	5	फ़ैरो द्वीप
64	72	description	5	फिजी द्वीप समूह
64	73	description	5	फिनलैंड
64	74	description	5	फ्रांस
64	75	description	5	फ्रेंच गयाना
64	76	description	5	फ्रेंच पॉलीनेशिया
64	77	description	5	फ्रांस के दक्षिणी और अंटार्कटिक भूमि
64	78	description	5	गैबॉन
64	79	description	5	गाम्बिया
64	80	description	5	जॉर्जिया
64	81	description	5	जर्मनी
64	82	description	5	घाना
64	83	description	5	जिब्राल्टर
64	84	description	5	ग्रीस
64	85	description	5	ग्रीनलैंड
64	86	description	5	ग्रेनाडा
64	87	description	5	गुआदेलूप
64	88	description	5	गुआम
64	89	description	5	ग्वाटेमाला
64	36	description	6	柬埔寨
64	90	description	5	गिन्नी
64	91	description	5	गिनी-बिसाऊ
64	92	description	5	गुयाना
64	93	description	5	हैती
64	94	description	5	हर्ड आइलैंड और मैकडोनाल्ड आइलैंड्स
64	95	description	5	होंडुरस
64	96	description	5	हांगकांग एसएआर
64	97	description	5	हंगरी
64	98	description	5	आइसलैंड
64	99	description	5	इंडिया
64	100	description	5	इंडोनेशिया
64	101	description	5	ईरान
64	102	description	5	इराक
64	103	description	5	आयरलैंड
64	104	description	5	इजराइल
64	105	description	5	इटली
64	106	description	5	जमैका
64	107	description	5	जापान
64	108	description	5	जॉर्डन
64	109	description	5	कजाखस्तान
64	110	description	5	केन्या
64	111	description	5	किरिबाती
64	112	description	5	कोरिया
64	113	description	5	कुवैट
64	114	description	5	किर्गिज़स्तान
64	115	description	5	लाओस
64	116	description	5	लातविया
64	117	description	5	लेबनान
64	118	description	5	लिसोटो
64	119	description	5	लाइबेरिया
64	120	description	5	लीबिया
64	121	description	5	लिकटेंस्टीन
64	122	description	5	लिथुआनिया
64	123	description	5	लक्जमबर्ग
64	124	description	5	मकाऊ एसएआर
64	125	description	5	"की मैसिडोनिया, पूर्व युगोस्लाव गणराज्य"
64	126	description	5	मेडागास्कर
64	127	description	5	मलावी
64	128	description	5	मलेशिया
64	129	description	5	मालदीव
64	130	description	5	माली
64	131	description	5	माल्टा
64	132	description	5	मार्शल द्वीपसमूह
64	133	description	5	मार्टीनिक
64	134	description	5	मॉरिटानिया
64	135	description	5	मॉरीशस
64	136	description	5	मैयट
64	138	description	5	माइक्रोनेशिया
64	139	description	5	मोलदोवा
64	140	description	5	मोनाको
64	141	description	5	मंगोलिया
64	142	description	5	मोंटसेराट
64	143	description	5	मोरक्को
64	144	description	5	मोजाम्बिक
64	145	description	5	म्यांमार
64	146	description	5	नामीबिया
64	147	description	5	नाउरू
64	148	description	5	नेपाल
64	149	description	5	नीदरलैंड
64	150	description	5	नीदरलैंड्स एंटाइल्स
64	151	description	5	न्यू कैलेडोनिया
64	152	description	5	न्यूजीलैंड
64	153	description	5	निकारागुआ
64	154	description	5	नाइजर
64	155	description	5	नाइजीरिया
64	156	description	5	नियू
64	157	description	5	नारफोक द्वीप
64	158	description	5	उत्तर कोरिया
64	159	description	5	उत्तरी मारियाना द्वीप
64	160	description	5	नॉर्वे
64	161	description	5	ओमान
64	162	description	5	पाकिस्तान
64	163	description	5	पलाऊ
64	164	description	5	पनामा
64	165	description	5	पापुआ न्यू गिनी
64	166	description	5	परागुआ
64	167	description	5	पेरू
64	168	description	5	फिलीपींस
64	169	description	5	पिटकैर्न
64	170	description	5	पोलैंड
64	171	description	5	पुर्तगाल
64	172	description	5	प्यूर्टो रिको
64	173	description	5	कतर
64	174	description	5	पुनर्मिलन
64	175	description	5	रोमानिया
64	176	description	5	रूस
64	177	description	5	रवांडा
64	178	description	5	समोआ
64	179	description	5	सैन मारिनो
64	180	description	5	Sï¿½1ï¿½7o Tomï¿½1ï¿½7 और Prï¿½1ï¿½7ncipe
64	181	description	5	सऊदी अरब
64	182	description	5	सेनेगल
64	183	description	5	सर्बिया और मोंटेनेग्रो
64	184	description	5	सेशेल्स
64	185	description	5	सियरा लिओन
64	186	description	5	सिंगापुर
64	187	description	5	स्लोवाकिया
64	188	description	5	स्लोवेनिया
64	37	description	6	喀麦隆
64	189	description	5	सोलोमन द्वीप
64	190	description	5	सोमालिया
64	191	description	5	दक्षिण अफ्रीका
64	192	description	5	दक्षिण जॉर्जिया और साउथ सैंडविच आइलैंड्स
64	193	description	5	स्पेन
64	194	description	5	श्री लंका
64	195	description	5	सेंट हेलेना
64	196	description	5	सेंट किट्स और नेविस
64	197	description	5	सेंट लुशिया
64	198	description	5	सेंट पियरे और मिकेलॉन
64	199	description	5	सेंट विंसेंट और ग्रेनेडाइंस
64	200	description	5	सूडान
64	201	description	5	सूरीनाम
64	202	description	5	स्वालबार्ड और जैन मायेन
64	203	description	5	स्वाजीलैंड
64	204	description	5	स्वीडन
64	205	description	5	स्विट्जरलैंड
64	206	description	5	सीरिया
64	207	description	5	ताइवान
64	208	description	5	तजाकिस्तान
64	209	description	5	तंजानिया
64	210	description	5	थाईलैंड
64	211	description	5	जाना
64	212	description	5	टोकेलाऊ
64	213	description	5	टोंगा
64	214	description	5	त्रिनिदाद और टोबैगो
64	215	description	5	ट्यूनीशिया
64	216	description	5	तुर्की
64	217	description	5	तुर्कमेनिस्तान
64	218	description	5	तुर्क्स और कैकोज़ द्वीपसमूह
64	219	description	5	तुवालु
64	220	description	5	युगांडा
64	221	description	5	यूक्रेन
64	222	description	5	संयुक्त अरब अमीरात
64	223	description	5	यूनाइटेड किंगडम
64	224	description	5	संयुक्त राज्य अमेरिका
64	225	description	5	संयुक्त राज्य अमेरिका के छोटे दूरस्थ द्वीपसमूह
64	226	description	5	उरुग्वे
64	227	description	5	उज़्बेकिस्तान
64	228	description	5	वानुअतु
64	229	description	5	वेटिकन सिटी
64	230	description	5	वेनेजुएला
64	231	description	5	वियतनाम
64	232	description	5	वर्जिन द्वीप समूह (ब्रिटिश)
64	233	description	5	वर्जिन द्वीपसमूह
64	234	description	5	वाली और फ़्युटुना
64	235	description	5	यमन
64	236	description	5	जाम्बिया
64	237	description	5	जिम्बाब्वे
69	1	welcome_message	5	"<Div> <br/> <पी शैली = font-size: 19px; फ़ॉन्ट वजन: बोल्ड;>! आपका स्वागत है अकड़नेवाला टट्टू बिलिंग करने के लिए </ p> <br/> <पी शैली = font-size: 14px; text-align = बाईं; padding-left: 15; > यहां से आप अपने नवीनतम चालान की समीक्षा करने और यह तुम भी अपने सभी पिछले चालान और भुगतान देख सकते हैं तुरन्त भुगतान पाने के लिए और स्वचालित भुगतान के लिए प्रणाली स्थापित कर सकते हैं। अपने क्रेडिट कार्ड के साथ </ p> <p शैली = font-size: 14px; padding-left; = बाईं text-align: 15;>। क्या आप आज क्या करना चाहते हैं क्या </ p> <उल शैली = font-size: 13px; padding-left; = बाईं text-align: 25;> <li> बाईं पट्टी पर लिंक का पालन करें, एक क्रेडिट कार्ड भुगतान प्रस्तुत करने के लिए </ li> <li> एक सूची देखने के लिए। अपने चालान की। सूची में पहली बार चालान अपने नवीनतम चालान है। एक ???? Invoicesâ ???? मेनू विकल्प पर क्लिक कर अपने विवरण देखने के लिए उस पर क्लिक करें। </ li> <li> एक सूची देखने के लिए अपने भुगतान की। सूची में पहली बार भुगतान अपने नवीनतम भुगतान है। एक ???? Paymentsâ ???? मेनू विकल्प पर क्लिक कर अपने विवरण देखने के लिए उस पर क्लिक करें। </ li> <li> एक क्रेडिट प्रदान करने के लिए कार्ड और फिर क्रेडिट कार्ड संपादित करें पर, मेनू विकल्प खाता पर क्लिक करें, स्वचालित भुगतान कर सकें। </ li> </ ul> </ div> "
69	2	welcome_message	5	"<Div> <br/> <पी शैली = font-size: 19px; फ़ॉन्ट वजन: बोल्ड;>! आपका स्वागत है Mordor इंक बिलिंग करने के लिए </ p> <br/> <पी शैली = font-size : 14px; text-align = बाईं; padding-left: 15; > यहां से आप अपने नवीनतम चालान की समीक्षा करने और यह तुम भी अपने सभी पिछले चालान और भुगतान देख सकते हैं तुरन्त भुगतान पाने के लिए और स्वत: के लिए प्रणाली स्थापित कर सकते हैं। । आपके क्रेडिट कार्ड से भुगतान </ p> <p शैली = font-size: 14px; padding-left; = बाईं text-align: 15;> क्या आप आज क्या करना चाहते हैं क्या </ p> <उल शैली = font-size: 13px; padding-left; = बाईं text-align: 25;> <li> बाईं पट्टी पर लिंक का पालन करें, एक क्रेडिट कार्ड भुगतान प्रस्तुत करने के लिए </ li> <li> एक को देखने के लिए। अपने चालान की सूची। सूची में पहली बार चालान अपने नवीनतम चालान है। एक पर ???? Invoicesâ ???? मेनू विकल्प पर क्लिक करें अपने विवरण देखने के लिए उस पर क्लिक करें। </ li> <li> एक को देखने के लिए अपने भुगतान की सूची। सूची में पहली बार भुगतान अपने नवीनतम भुगतान है। एक पर ???? Paymentsâ ???? मेनू विकल्प पर क्लिक करें अपने विवरण देखने के लिए उस पर क्लिक करें। </ li> <li> एक प्रदान करने के लिए क्रेडिट कार्ड और फिर क्रेडिट कार्ड संपादित करें पर, मेनू विकल्प खाता पर क्लिक करें, स्वचालित भुगतान कर सकें। </ li> </ ul> </ div> "
73	1	description	5	व्यवस्था
73	2	description	5	बीजक
73	3	description	5	भुगतान
73	4	description	5	धन की वापसी
73	5	description	5	ग्राहक
73	6	description	5	साथी
73	7	description	5	साथी चयनित
73	8	description	5	उपयोगकर्ता
73	9	description	5	मद
81	1	description	5	सक्रिय
81	2	description	5	विचाराधीन सदस्यता खत्म
81	3	description	5	सदस्यता रद्द
81	4	description	5	लंबित समय सीमा समाप्त
81	5	description	5	समय सीमा समाप्त
81	6	description	5	Nonsubscriber
81	7	description	5	बंद
88	1	description	5	सक्रिय
88	2	description	5	निष्क्रिय
88	3	description	5	सक्रिय लंबित
88	4	description	5	विचाराधीन निष्क्रिय
88	5	description	5	विफल
88	6	description	5	अनुपलब्ध
89	1	description	5	कोई नहीं
89	2	description	5	प्रीपेड बैलेंस
89	3	description	5	क्रेडिट सीमा
90	1	description	5	भुगतान किया
90	2	description	5	अवैतनिक
90	3	description	5	किया
91	1	description	5	डन और बिल
91	2	description	5	डन और बिल नहीं
91	3	description	5	त्रुटि का पता चला
91	4	description	5	त्रुटि घोषित
92	1	description	5	रनिंग
92	2	description	5	समाप्त: सफल
92	3	description	5	समाप्त: विफल रहा है
99	1	description	5	परामर्श शुल्क
99	2	description	5	भुगतान संसाधक
99	3	description	5	आईपी ​​पता
100	1	description	5	कुल राशि की अवधि के आधार पर वर्गीकृत चालान।
100	2	description	5	विस्तृत संतुलन उम्र बढ़ने की रिपोर्ट। उत्कृष्ट ग्राहक शेष राशि की उम्र से पता चलता है।
100	3	description	5	उपयोगकर्ताओं की संख्या एक विशेष उत्पाद के लिए सदस्यता ली।
100	4	description	5	कुल भुगतान राशि की अवधि के आधार पर वर्गीकृत प्राप्त किया।
100	5	description	5	एक अवधि के भीतर बनाया ग्राहकों की संख्या।
100	6	description	5	प्रति ग्राहक कुल राजस्व (प्राप्त भुगतान की राशि)।
100	7	description	5	सरल खातों चालू खाते में शेष राशि दिखा प्राप्य रिपोर्ट।
100	8	description	5	दिए गए दिन के लिए सभी चालान आरोपों के सामान्य खाता विवरण।
100	9	description	5	"आइटम प्रकार से वर्गीकृत किया दिए गए दिन के लिए सभी चालान आरोपों के सामान्य खाता सारांश।"
100	11	description	5	कुल उत्पाद की श्रेणी के आधार पर वर्गीकृत प्रति ग्राहक चालान।
100	12	description	5	कुल वर्ष के आधार पर वर्गीकृत पिछले कुछ वर्षों में प्रति ग्राहक चालान।
14	2601	description	6	柠檬水 - 包括在计划
100	13	description	5	दिनों की निर्धारित संख्या के भीतर उपयोगकर्ता गतिविधि के वक्तव्य
101	1	description	5	चालान रिपोर्ट
101	2	description	5	आदेश रिपोर्टें
101	3	description	5	भुगतान रिपोर्ट
101	4	description	5	ग्राहक रिपोर्टों
104	1	description	5	चालान
104	2	description	5	आदेश
104	3	description	5	भुगतान
104	4	description	5	उपयोगकर्ता
104	5	description	5	कस्टम सूचनाएं
108	1	description	5	समूह के सदस्य
108	101	description	5	DefaultStatus
108	102	description	5	AddToOrderStatus
108	103	description	5	Available2
108	104	description	5	UnAvailable2
111	1	description	5	बुनियादी
111	2	description	5	बुनियादी
111	3	description	5	प्राइवेट
111	4	description	5	व्यापार
111	5	description	5	प्राइवेट
113	19	errorMessage	5	मान्य नहीं ईमेल
113	37	errorMessage	5	मान्य नहीं ईमेल
113	57	errorMessage	5	मान्य नहीं ईमेल
113	58	errorMessage	5	मान्य नहीं ईमेल
113	71	errorMessage	5	मान्य नहीं ईमेल
113	80	errorMessage	5	मान्य नहीं ईमेल
114	7	errorMessage	5	भुगतान कार्ड नंबर मान्य नहीं है
114	8	errorMessage	5	समाप्ति की तारीख प्रारूप माह / वर्ष में होना चाहिए
114	9	errorMessage	5	ए.बी.ए. रूटिंग या बैंक खाता संख्या केवल अंक हो सकता है
114	10	errorMessage	5	भुगतान कार्ड नंबर मान्य नहीं है
114	11	errorMessage	5	समाप्ति की तारीख प्रारूप माह / वर्ष में होना चाहिए
114	12	errorMessage	5	ए.बी.ए. रूटिंग या बैंक खाता संख्या केवल अंक हो सकता है
114	16	errorMessage	5	पासवर्डों 90 दिन से पहले समाप्त हो जाना चाहिए
23	25	description	6	代理佣金的计算过程。
23	26	description	6	“与远程位置的文件交换，上传和下载”
114	15	errorMessage	5	ए.बी.ए. रूटिंग या बैंक खाता संख्या केवल अंक हो सकता है
114	17	errorMessage	5	निष्क्रिय खाता चेकों को जल्दी से कम 90 दिनों के लिए किया जाना चाहिए
114	18	errorMessage	5	आरक्षण अवधि 0 और 600000 के बीच होना चाहिए
115	1	description	5	लंबित
115	2	description	5	त्रुटि लागू
115	3	description	5	आवेदन
4	1	description	6	美国美元
4	2	description	6	加拿大元
4	3	description	6	欧元
4	4	description	6	日元
4	5	description	6	英镑
4	6	description	6	韩元
4	7	description	6	瑞士法郎
4	8	description	6	瑞典克朗
4	9	description	6	新加坡元
4	10	description	6	马来西亚林吉特
4	11	description	6	澳大利亚元
4	12	description	6	印度卢比
4	13	description	6	中国人民币
6	1	description	6	月
6	2	description	6	周
6	3	description	6	日
6	4	description	6	年
6	5	description	6	半月刊
7	1	description	6	电子邮件
7	2	description	6	纸
7	3	description	6	电子邮件+纸
9	1	description	6	活性
9	2	description	6	老龄化第1天
9	3	description	6	4老化日
9	4	description	6	5老化日
9	5	description	6	老龄化15天
9	6	description	6	老化日16
9	7	description	6	老龄化27天
9	8	description	6	老龄化30天
9	9	description	6	老龄化31天
9	10	description	6	老龄化32天
9	11	description	6	老化日40
9	12	description	6	老化日45
9	13	description	6	老化日50
9	14	description	6	老化日55
9	15	description	6	老化日65
9	16	description	6	老化日90
9	17	description	6	老化日180
14	1	description	6	柠檬水 - 每天1次月票
14	2	description	6	柠檬水 - 所有你能每月喝
14	3	description	6	咖啡 - 每天一 - 每月
14	4	description	6	毒藤汁（冷）
14	14	description	6	10％精灵的折扣。
14	24	description	6	取消手续费
14	240	description	6	货币测试项目
14	250	description	6	柠檬水计划
14	251	description	6	柠檬水计划 - 安装费
14	260	description	6	从WS项目
14	270	description	6	逾期付款违约金
14	1250	description	6	AM-1
14	2600	description	6	柠檬水 - 通用
14	2700	description	6	长途A计划 - 固定利率
14	2701	description	6	长途B计划 - 固定利率
14	2702	description	6	长途计划 - 包括1000分钟
14	2800	description	6	长途电话
14	2801	description	6	长途电话 - 包括
14	2900	description	6	长途电话 - 通用
14	3000	description	6	疯狂Brian的优惠计划
14	3100	description	6	百分比线测试计划
14	3101	description	6	酷计划
14	320100	description	6	CALL 1
17	1	description	6	一次
17	2	description	6	每月一次
17	3	description	6	每月一次
17	4	description	6	每3个月
17	5	description	6	所有订单
17	6	description	6	每月一次
18	1	description	6	项目
18	2	description	6	税
18	3	description	6	罚款
18	4	description	6	折扣
18	5	description	6	订阅
18	6	description	6	计划
19	1	description	6	预付费
19	2	description	6	后付费
20	1	description	6	活性
20	2	description	6	完成
20	3	description	6	暂停
20	4	description	6	暂停（自动）
20	400	description	6	测试
23	1	description	6	项目管理和订单行的总计算
23	2	description	6	计费流程：阶滤波器
23	3	description	6	开票过程：发票过滤器
23	4	description	6	发票介绍
23	5	description	6	计费流程：订单周期计算
23	6	description	6	支付网关整合
23	7	description	6	通知
23	8	description	6	支付工具的选择
23	9	description	6	处罚逾期发票
23	10	description	6	当一个支付网关关闭警报
23	11	description	6	订阅状态管理器
23	12	description	6	异步支付处理参数
23	13	description	6	添加一个产品订购
23	14	description	6	产品价格
23	15	description	6	调解器
23	16	description	6	调解处理器
23	17	description	6	通用内部事件监听器
23	19	description	6	对预付费余额/授信额度购买验证
23	20	description	6	计费流程：客户选择
23	21	description	6	调解错误处理程序
23	22	description	6	计划插件
23	23	description	6	规则发电机
23	24	description	6	老龄化，为客户提供过期发票
64	38	description	6	加拿大
24	1	description	6	“计算订单总额和总的每一行，考虑到项目的价格，数量和价格是否是个与否。”
24	1	title	6	默认订单总计
24	2	description	6	增加了额外的线路，以与一定百分比的电荷以便表示增值税。
24	2	title	6	增值税
24	3	description	6	一个非常简单的实现，设置发票的到期日。截止日期是刚刚加入的时间内，以发票日期开始计算。
24	3	title	6	发票到期日
24	4	description	6	“这个任务将复制在订单和发票到新发票的所有线路，考虑到涉及每个订单的期间，但期间不是馏分。它不会复制是税收的线路。每行的数量和总将通过的周期量相乘。“
24	4	title	6	默认发票组成。
24	5	description	6	“决定如果订单应包括在发票对于给定的记帐过程，这是通过采取记帐过程的时间跨度，顺序期间，活性自/至等做”
24	5	title	6	标准阶滤波器
24	6	description	6	“始终返回true，这意味着逾期发票将结转到一个新的发票。”
24	6	title	6	标准发票过滤器
24	7	description	6	“计算要被包括在发票的开始和结束时期。这是通过采取记帐过程的时间跨度，顺序期间，因为活性完成/直到等。”
24	7	title	6	默认排序期
24	8	description	6	集成与authorize.net支付网关。
24	8	title	6	Authorize.net支付处理器
24	9	description	6	通知通过发送电子邮件的用户。它支持文本和HTML电子邮件
24	9	title	6	标准的电子邮件通知
24	10	description	6	“查找的支付方法提供给顾客的信息，优先的信用卡。换言之，将返回的信用汽车客户或在该顺序的ACH的信息”。
24	10	title	6	默认的付款信息
24	11	description	6	插件仅用于测试
24	11	title	6	对于合作伙伴的付款测试插件
24	12	description	6	将生成一个发票的PDF版本。
24	12	title	6	PDF发票的通知
24	14	description	6	“返回总是假的，这使得jBilling永远延续发票到另一个新的发票。”
24	14	title	6	没有发票结转
24	15	description	6	将创建一个新的秩序带罚项。该项目被取为参数的任务。
24	15	title	6	罚息任务
24	16	description	6	“扩展BasicOrderFilterTask，修改日期，使订单适用的数月之前，这将是使用默认过滤器。”
24	16	title	6	预期阶滤波器
24	17	description	6	“扩展BasicOrderPeriodTask，修改日期，使订单适用的数月之前，ITD是通过使用默认的任务。”
24	17	title	6	预计订单周期。
24	19	description	6	扩展了标准authorize.net支付处理也处理了付款后发电子邮件至本公司。
24	19	title	6	电子邮件和工艺authorize.net
24	20	description	6	当一个支付网关关闭发送电子邮件到计费管理员为报警信号。
24	20	title	6	支付网关下来报警
24	123	title	6	触发文件下载/上传
24	21	description	6	测试付款处理器执行方案能够在不使用真实的支付网关测试jBillings功能。
24	21	title	6	测试付款处理器
24	22	description	6	允许顾客被指定一个特定的支付网关。它检查自定义联系人字段来标识的网关，然后代表实际的支付处理到另一个插件。
24	22	title	6	基于自定义字段路由器付​​款处理器
24	23	description	6	“它决定如何的支付事件影响的用户的预订状态，考虑到其当前状态和一个状态机。”
24	23	title	6	默认订阅状态经理
24	24	description	6	集成与ACH电子商务支付网关。
24	24	title	6	ACH商务部付款处理器
24	25	description	6	一个虚拟的任务，不用于异步支付处理添加任何参数。这是默认的。
24	25	title	6	标准的异步参数
24	26	description	6	这个插件增加了参数异步支付处理让每个支付处理一个处理消息的bean。这是用在组合与路由器付款处理器插件。
24	26	title	6	路由器异步参数
24	28	description	6	“它增加了项目的订单。如果该项目已经在命令，它仅更新的数量。”
24	28	title	6	标准项目经理
24	29	description	6	“这是一个以规则为基础的插件，它会做基本的项目经理做（实际上是调用它），但随后会执行外部规则。这些外部的规则有完全的控制上的改变是获得新订单项目“。
24	29	title	6	规则项目经理
24	30	description	6	“这是一个以规则为基础的插件，它的总的订单行（通常这是价格乘以数量）计算，允许对外部规则的执行。”
24	30	title	6	规则线路总
24	31	description	6	这是一个以规则为基础的插件。它通过执行外部规则给出了价格的项目。然后，您可以在外部添加逻辑定价。它也由具有访问中介的定价数据集成与中介过程。
24	31	title	6	规则定价
24	32	description	6	这是一个阅读器调解过程。它从一个文本文件，其字段一个字符（或字符串）是分开的读取记录。
24	32	title	6	分离文件阅读器
24	33	description	6	“这是一个以规则为基础的插件（见第七章）。这需要一个事件的记录，从调解程序并执行外部规则翻译战绩进入计费有意义的数据。这是中介组件的核心，看？电信指南？获得更多的帮助。“
24	33	title	6	规则调解处理器
24	34	description	6	“这是一个阅读器的调解过程，它从一个文本文件，其字段位置固定读取记录，并且记录具有固定的长度。”
24	34	title	6	固定长度的文件阅读器
24	35	description	6	“这是完全一样的标准支付信息的任务，唯一的区别是，它不验证，如果信用卡过期。只有当你想提交付款使用过期的信用卡使用此插件。”
24	35	title	6	未经验证付款信息
64	39	description	6	佛得角
24	36	description	6	“这个插件只用于测试目的，而是发送电子邮件（或其他实际通知），它只是存储在一个名为emails_sent.txt文件要发送的文字。”
24	36	title	6	通知任务进行测试
24	37	description	6	这个插件考虑到外地周期的订单开始计算分数阶段。
24	37	title	6	订单周期计算器亲的评级。
24	38	description	6	“当从订单生成发票时，该插件将有利于利率一段时间服用，每日为最小计费单位的任何部分。”
24	38	title	6	与亲评级发票组成任务（一天分数）
24	39	description	6	集成与Intraanuity支付网关。
24	39	title	6	支付过程的Intraanuity支付网关
24	40	description	6	这个插件将创建一个新的秩序具有负价，以反映信贷当订单已经已开发票的期间内取消。
24	40	title	6	自动取消信贷。
24	42	description	6	用于到达真正的第三方支付机构的阻止付款。典型的配置是在处理链首付款处理器。
24	42	title	6	黑名单过滤付款处理器。
24	43	description	6	“导致用户及其相关的详细信息（如信用卡号，电话号码等）的时候他们的状态将暂停或更高列入黑名单。”
24	43	title	6	当他们的状态将暂停或更高黑名单用户。
24	44	description	6	这是一个阅读器调解过程。它从一个JDBC数据库源读取记录。
24	44	title	6	JDBC调解器。
24	45	description	6	“这是一个阅读器的调解过程，它是JDBC阅读器的扩展，允许一个MySQL数据库源的轻松配置。”
24	45	title	6	MySQL的调解器。
24	49	description	6	代表们以支付货币的实际支付处理另一个插件。
24	49	title	6	货币路由器付款处理器
24	51	description	6	该过滤器将只与一个积极平衡的发票可结转到下一发票。
24	51	title	6	筛选出的结转负的发票。
24	52	description	6	它会产生与每个生成的发票一行的文件。
24	52	title	6	文件发票出口国。
24	53	description	6	它会调用一个包的规则，当一个内部事件发生。
24	53	title	6	规则呼叫者的事件。
24	54	description	6	这将更新客户的动态平衡（预付费或信用额度），当事件影响的平衡发生。
24	54	title	6	动态余额管理
24	55	title	6	根据客户的账面余额验证。
24	56	title	6	根据规则，平衡验证。
24	57	description	6	集成的支付网关支付处理。
24	57	title	6	付款处理器，用于支付网关。
24	58	description	6	“保存在支付网关的信用卡信息，而不是jBilling DB”。
24	58	title	6	信用卡在外部存储。
24	59	title	6	规则项目经理2
24	60	title	6	规则线共计 - 2
24	124	description	6	InternalEventsTask类型的可插入任务监控，如果用户预付费余额低于信贷限制1级或2级和发送通知。
24	61	description	6	这是一个以规则为基础的插件与jBilling 2.2.x中的中介模块兼容它通过执行外部规则给出了价格的项目。然后，您可以在外部添加逻辑定价。它也由具有访问中介的定价数据集成与中介过程。
24	61	title	6	规则定价2
24	63	description	6	一个假插件测试，将存储在外部付款。
24	63	title	6	用于外部存储测试付款处理器。
24	64	description	6	付款处理器插件与RBS WorldPay的整合
24	64	title	6	WorldPay的整合
24	65	description	6	“付款处理器插件与RBS WorldPay的集成，它存储信用卡信息（号码等）的网关。”
24	65	title	6	与外部存储WorldPay的整合
24	66	description	6	“监控客户的平衡，在达到一个极限，它要求一个实时支付”
24	66	title	6	自动充值
24	67	description	6	对于与Beanstream支付网关集成付款处理器
24	67	title	6	Beanstream网关整合
24	68	description	6	与圣人支付网关集成付款处理器
24	68	title	6	贤者支付网关集成
24	69	description	6	在开票过程中运行到选择评估哪些用户调用。这种基本实现返回每个用户未在暂停（或更糟）状态
24	69	title	6	标准计费过程用户过滤器
24	70	description	6	在开票过程中运行到选择评估哪些用户调用。这仅返回用户有下一个发票日期早于结算处理订单。
24	70	title	6	选择开票过程中的用户过滤器
24	71	description	6	事件记录有错误被保存到一个文件
24	73	description	6	事件记录有错误被保存到数据库表
24	75	description	6	提交支付给贝宝作为贝宝支付网关和存储信用卡信息，以及
24	75	title	6	与外部存储贝宝集成
24	76	description	6	提交支付authorize.net在authorize.net支付网关和存储信用卡信息，以及
24	76	title	6	与外部存储Authorize.net整合
24	77	description	6	代表们根据付款的付款方式实际支付处理另一个插件。
24	77	title	6	付款方式的路由器付款处理器
24	78	description	6	动态生成基于Velocity模板规则。
24	78	title	6	动态规则生成器
24	79	description	6	计划的任务执行调解程序。
24	79	title	6	调解过程任务
24	80	description	6	计划的任务来执行结算过程。
24	80	title	6	开票过程任务
24	87	description	6	年龄基于天数该帐户是过期的用户。
24	87	title	6	基本衰老
24	88	description	6	计划的任务要执行的衰老过程。
24	88	title	6	老龄化进程的任务
24	89	description	6	中世纪的基础上个工作日（节假日除外）的数量用户的帐户已经过期。
24	89	title	6	营业日老化
47	15	description	6	“一个合作伙伴有支付准备好了，但没有支付工具。”
24	90	description	6	类型SimpleTaxCompositionTask的可插入任务税目适用于发票，如果合作伙伴的国家代码相匹配。
24	90	title	6	国家税务发票组成任务
24	91	description	6	类型AbstractChargeTask的可插入任务点球适用于有超过一个可配置的天期限到期日的发票。
24	91	title	6	付款方式惩罚任务
24	95	description	6	类型的支付可插拔任务信息的任务，首先检查比，如果没有数据的首选方法是搜索其他付款方式首选付款方式
24	95	title	6	替代付款方式任务
24	97	description	6	这个任务是负责应用％-age或固定数额罚款的过期发票。这个任务是强大的，因为它执行此操作之前的计费过程中收集的订单。
24	97	title	6	点球任务的Overude发票
24	101	description	6	在为本次活动自定义通知任务需要定制通知消息，并执行通知时，内部事件发生
24	101	title	6	基于事件的自定义通知任务
24	102	description	6	这是一个例子插件创建一个新的联系人时调用一个远程Web服务。
24	102	title	6	示例Web服务插件
24	105	description	6	这个插件通过咨询Suretax引擎增加税收行的发票。
24	105	title	6	Suretax插件
24	107	description	6	这个插件将设置一个负数发票的平衡，总为0，创造一个信用支付剩余金额。
24	107	title	6	信用列入负面发票
24	108	description	6	InternalEventsTask的这种类型的可插式任务并监控如果用户预付费余额低于阈值电平并发送通知。
24	108	title	6	用户平衡值通知任务
24	109	description	6	该插件提供了需要发送的每一个状态的用户状态（老化步骤），并通知之间的映射
24	109	title	6	每个老化步骤定制用户通知
24	110	description	6	此任务将删除超过一定时间的旧文件。
24	110	title	6	删除旧文件
24	111	description	6	这个插件将更新AssetTransitions当一个资产状态更改。
24	111	title	6	更新资产转换
24	112	description	6	当连接顺序合同期满该插件将消除资产所有者。
24	112	title	6	除去资产没有完订单
24	113	description	6	类型InternalEventsTask的可插入任务监控，当订单的activeUntil变化
24	113	title	6	订单取消任务
24	117	description	6	该任务计划，计算代理的佣金的过程。
24	117	title	6	计算代理人的佣金
24	118	description	6	这个任务计算代理“委员会。
24	118	title	6	基本代理人的佣金任务
24	119	description	6	这个插件将创建支付佣金时，款项将发票联未链接。
24	119	title	6	生成支付佣金代理商。
24	123	description	6	触发文件下载/上传对抗第三方系统
24	124	title	6	用户金额限制通知任务
24	125	description	6	这个插件将顺序更改过程中更改订单状态适用于为了改变选择。
24	125	title	6	更改订单更改订单状态的申请
24	126	description	6	这是一个计划的插件，需要在尚未登录的为优先55指定的天数和更新存在状态，未激活用户。
24	126	title	6	不活跃的用户帐户管理插件
24	127	description	6	这是处理基础上的项目使用的价格计算（缺省实现）。
24	127	title	6	基本定价任务
28	2	description	6	主
28	3	description	6	主
28	4	description	6	额外的联系
35	1	description	6	支票
35	2	description	6	签证
35	3	description	6	万事达
35	4	description	6	AMEX
35	5	description	6	ACH
35	6	description	6	发现
35	7	description	6	食客
35	8	description	6	贝宝
35	9	description	6	支付网关键
35	15	description	6	信用
41	1	description	6	成功
41	2	description	6	失败
41	3	description	6	处理器不可用
41	4	description	6	进入
46	1	description	6	结算流程
46	2	description	6	用户维护
46	3	description	6	项目维护
46	4	description	6	项目类型维护
46	5	description	6	项目用户维修价格
46	6	description	6	推广维护
46	7	description	6	秩序维护
46	8	description	6	信用卡维修
46	9	description	6	发票维护
47	1	description	6	预付费订单未付款的时间计费过程日期之前
47	2	description	6	命令在过程的日期没有活动的时间。
47	3	description	6	至少有一个完整的周期已被计费。
47	4	description	6	已经记帐的当前日期。
47	5	description	6	这个命令必须maked排除在最后一道工序。
47	6	description	6	预付费订单到期后，被处理。
47	7	description	6	一排被标记为删除。
47	8	description	6	用户密码已更改。
47	9	description	6	一排已更新。
47	10	description	6	“运行计费过程，但审查发现未经批准的。”
47	11	description	6	“运行计费过程，需要检讨，但不存在。”
47	12	description	6	用户状态更改。
47	13	description	6	订单状态被改变。
47	14	description	6	“用户不得不被老化，但也有配置没有更多的步骤”。
47	16	description	6	采购订单的手动应用到发票。
47	17	description	6	该命令行已更新
47	18	description	6	订单下一个结算日期已更改
47	19	description	6	最后API调用来获取用户订阅状态转变
47	20	description	6	用户订阅状态已经改变
47	21	description	6	用户帐户被锁定
47	22	description	6	该命令主要认购标志被改变
47	24	description	6	未找到有效的付款方式。付款请求已被取消
47	25	description	6	一个新行已创建
47	26	description	6	“一个发票的订单被取消，信用为了创建”
47	27	description	6	用户ID添加到黑名单
47	28	description	6	用户ID被从黑名单中删除
47	32	description	6	用户订阅地位并没有改变
47	33	description	6	一个用户的动态的平衡已经改变
47	34	description	6	如果孩子标志已更改发票
47	35	description	6	经销商订购了发票产生的子实体中的根实体创建的。
47	37	description	6	失败的登录尝试。
47	38	description	6	用户登录成功
47	39	description	6	用户注销成功
47	40	description	6	用户登录失败是由于不正确的用户名/密码
50	4	description	6	宽限期
50	4	instruction	6	宽限期天老客户有逾期发票前。
50	13	description	6	自递纸发票
50	13	instruction	6	设置为“1”，以电子邮件的发票作为记账公司。 “0”提供发票的jBilling。
50	14	description	6	包括客户笔记发票
50	14	instruction	6	“设置为”1“，在发票显示的笔记，”0“禁用”。
50	15	description	6	到期前的天数为订单通知
50	15	instruction	6	前几天的命令“有效，直到”日发送第一通知。留空将禁用。
50	16	description	6	到期前的天数为订单通知2
50	16	instruction	6	前几天的命令“有效，直到”日发送第二通知。留空将禁用。
50	17	description	6	到期前的天数为订单通知3
50	17	instruction	6	前几天的命令“有效，直到”日送3日通知。留空将禁用。
50	18	description	6	发票号码前缀
50	18	instruction	6	对于产生的发票公用号前缀值。
50	19	description	6	下一步发票号码
50	19	instruction	6	的当前值生成发票公用号。新发票将通过增加此值被分配一个公共号码。
50	20	description	6	手工发票缺失
50	20	instruction	6	“设置为”1“，以允许发票被删除，”0“以禁止”。
50	21	description	6	使用发票的催
50	21	instruction	6	“设置为”1“，使发票的提醒通知，”0“禁用”。
50	22	description	6	天数发票代的第一次提醒后，
50	23	description	6	明年提醒天数
50	24	description	6	数据Fattura精细MESE
50	24	instruction	6	“设置为”1“启用，”0“禁用”。
50	25	description	6	使用过期罚款（利息）。
50	25	instruction	6	“设置为”1“，使收费过程来计算逾期付款利息，”0“为禁用。利息的计算是由选定的处罚插件处理。”
50	27	description	6	使用顺序期待。
50	27	instruction	6	“设置为”1“用”“OrderFilterAnticipateTask”“要发票数月提前，”0“为禁用。插件必须单独配置。”
50	28	description	6	贝宝帐户。
50	28	instruction	6	PayPal帐户名称。
50	29	description	6	PayPal按钮的URL。
50	29	instruction	6	“那里的PayPal按钮的图形所在的URL，显示的按钮，客户在他们正在付款，默认通常是最好的选择，除非是必要的另一种语言。”
50	30	description	6	网址HTTP老化回调。
50	30	instruction	6	网址为HTTP回调调用时老化过程改变的用户的状态。
50	31	description	6	连续使用发票日期。
50	31	instruction	6	“默认为空这首已经是一个日期（格式为YYYY-MM-DD例如：2000-01-31），该系统将确保所有的发票都有其日期增量方式的任何发票。一个更大的“ID”也将有较大的（或等于）日期。换句话说，一个新的发票不能有一个更早的日期比现有的（旧的）发票。要使用此首选项，将其设置为一个字符串的日期从哪里开始。这种偏好将不会被使用，如果空白“
50	32	description	6	附加PDF发票的电子邮件通知。
50	32	instruction	6	设置为“1”附上发票的PDF版本的所有发票的通知邮件。 “0”为禁用。
50	33	description	6	强制每张发票一个数量级。
50	33	instruction	6	“设置为”1“以显示”，“包括在单独的发票”，“标志的量级。”0“以禁止”。
50	35	description	6	添加订单ID为发票行。
50	35	instruction	6	“设置为”1“，包括在所产生的发票行的描述文本的顺序的编号。”0“为禁用。这可以帮助轻松地跟踪它的确切订单，负责在发票行，考虑到许多命令可以包括在单个发票“。
50	36	description	6	让客户修改自己的联系信息。
50	36	instruction	6	设置为“1”，让客户编辑自己的联系信息。 “0”为禁用。
50	38	description	6	链接老化客户的用户状态。
50	38	instruction	6	设置为1来改变用户的年龄在用户的预订状态。 “0”为禁用。
50	39	description	6	锁定用户的登录尝试失败之后。
50	39	instruction	6	“重试次数，以便锁定用户帐户之前，锁定的用户帐户将被锁定在偏好68.要启用此锁定功能指定的分钟数，设置首选项68到非零值是必须的。”
50	40	description	6	天后过期用户密码。
50	40	instruction	6	“如果大于零，它代表的天数，一个口令是有效的。这些天之后，密码已过期，用户被强制改变它。”
50	41	description	6	使用的主要认购订单。
59	13	description	6	检查客户
50	41	instruction	6	设置为1，以允许“主订阅标志的使用订单时确定在哪里放置电荷从外部事件即将此标志只读由中介过程。
50	42	description	6	利用Pro评级。
50	42	instruction	6	设置为“1”，以允许使用亲评级发票一段分数。显示了顺序的“循环”属性。请注意，您需要配置相应的插件，此功能才能充分发挥作用。
50	43	description	6	使用支付黑名单。
50	43	instruction	6	“如果支付黑名单功能时，该设定为PaymentFilterTask插件配置的ID，请参阅文件的黑名单部分。”
50	44	description	6	允许负付款。
50	44	instruction	6	设置为“1”允许负付款。 “0”来禁用
50	45	description	6	延迟负数发票付款。
50	45	instruction	6	“设置为”1“拖延付款的负面发票金额，导致平衡被结转到下一张发票。从转移到他们的其他发票的，有负面的余额发票被允许立即做出负面支付（信用卡），如果必要的。“0”来禁用。偏好44 46通常也被激活。“
50	46	description	6	允许发票没有订单。
50	46	instruction	6	设置为“1”，使发票负余额产生不是由任何订单，使他们的余额总是会得到结转到一个新的发票的信用发生了新的发票。 “0”为禁用。偏好44 45通常也被激活。
50	47	description	6	最近读调解记录ID。
50	47	instruction	6	在调解过程中读取的最后一条记录的ID。这被用来确定哪些记录是“新的”，需要进行读取。
50	49	description	6	自动客户充值门槛。
50	49	instruction	6	自动付款的阈值。预付费用户提供了一个自动充值值集将产生一个自动付款时账户余额低于这个门槛。请注意，您需要配置AutoRechargeTask插件，此功能才能充分发挥作用。
50	50	description	6	发票小数四舍五入。
50	50	instruction	6	要显示在发票上的小数位数。默认为2。
50	51	description	6	为此忽略衰老最低余额
50	51	instruction	6	“最低余额，该企业是愿意，如果逾期发票，不容忽视。如果设置，该值将确定用户是否有足够的余额继续老化或接收通知未付发票”
50	52	description	6	安装最新的发票给所有逾期通知。
50	52	instruction	6	“逾期通知逾期1 2 3默认情况下不重视发票的通知邮件。通过此偏好，最新的发票可以自动连接到这样的通知。”
50	53	description	6	力独特的电子邮件
50	53	instruction	6	为了迫使之间的用户/客户提供独特的邮件进入公司设置为1。设置为0。
50	55	description	6	唯一的产品代码
50	55	instruction	6	“允许唯一的产品代码，如果设置了产品代码或一个产品的内部编号/项目将被强制为独特的”
50	61	description	6	代理佣金类型
50	61	instruction	6	“定义默认的代理人的佣金类型的实体之一：发票，付款”
50	63	description	6	应该使用jqGrid的对表
50	63	instruction	6	设置为0以使用公共布局或设置为1以使用jqGrid的网站上的表
50	64	description	6	直径目的地境界
64	103	description	6	爱尔兰
50	64	instruction	6	“该领域进行充电。这可以用于路由Diameter消息，因此应该与本地配置的领域。”
50	65	description	6	直径配额阈值
50	65	instruction	6	当秒数仍是呼叫处理单元应要求重新授权。
50	66	description	6	直径会议宽限期
50	66	instruction	6	几秒钟之前等待的直径会话强制关闭。
50	67	description	6	直径单位乘数/除数
50	67	instruction	6	从直径接收的单位值被划分/乘以该系数输入秒转换成其他时间单位。值<1设定倍频为1。
50	68	description	6	帐户锁定时间
50	68	instruction	6	分用户的帐户将继续允许的重试次数（39首）后锁定的数量已耗尽。
50	70	description	6	到期不活动的帐户天后
50	70	instruction	6	天数之后，用户的帐户将变为无效。这将禁用登录到jBilling该用户的能力。
50	71	description	6	忘记密码到期（小时）
50	71	instruction	6	小时，直到链接，密码更改到期。
50	75	description	6	如果证书被默认创建
50	75	instruction	6	在创建用户时1有默认创建的凭据。 0（默认值），要求在创建凭证创建请求。
50	76	description	6	默认资产预约时间
50	76	instruction	6	在这里添加默认的资产保留分钟。它会工作，如果产品是资产启用。 （必须大于零）
52	1	description	6	发票（电子邮件）
52	2	description	6	用户重新激活
52	3	description	6	用户逾期
52	4	description	6	用户逾期2
52	5	description	6	用户逾期3
52	6	description	6	用户暂停
52	7	description	6	用户暂停2
52	8	description	6	用户暂停3
52	9	description	6	用户已删除
52	12	description	6	发票（纸）
52	13	description	6	订购即将到期。步骤1
52	14	description	6	订购即将到期。第2步
52	15	description	6	订购即将到期。第3步
52	16	description	6	付款（成功）
52	17	description	6	支付失败）
52	18	description	6	发票提示
52	19	description	6	更新信用卡
52	20	description	6	密码丢失
52	21	description	6	证书创建
52	22	description	6	支付进入
52	23	description	6	付款（退款）
52	24	description	6	余额低于阈值
52	25	description	6	用法池消费
52	26	description	6	信贷限制1
52	27	description	6	信贷限制2
59	10	description	6	创建客户
59	11	description	6	编辑客户
59	12	description	6	删除用户
59	15	description	6	查看客户详细信息
59	16	description	6	下载客户CSV
59	17	description	6	查看所有客户
59	18	description	6	查看客户子帐户
59	20	description	6	创建订单
59	21	description	6	编辑订单
59	22	description	6	删除订单
59	23	description	6	生成发票订单
59	24	description	6	查看订单详情
59	25	description	6	为了下载CSV
59	26	description	6	编辑线价格
59	27	description	6	编辑线路描述
59	28	description	6	查看所有客户
59	29	description	6	查看客户子帐户
59	30	description	6	创建付款
59	31	description	6	编辑付款
59	32	description	6	删除付款
59	33	description	6	链接付款发票
59	34	description	6	查看付款细节
59	35	description	6	下载支付CSV
59	36	description	6	查看所有客户
59	37	description	6	查看客户子帐户
59	40	description	6	创建产品
59	41	description	6	编辑产品
59	42	description	6	删除产品
59	43	description	6	查看产品详细
59	44	description	6	下载产品CSV
59	50	description	6	创建产品类别
59	51	description	6	编辑产品类别
59	52	description	6	删除产品类别
59	70	description	6	删除发票
59	71	description	6	发送发票通知
59	72	description	6	查看发票明细
59	73	description	6	下载发票CSV
59	74	description	6	查看所有客户
59	75	description	6	查看客户子帐户
59	80	description	6	批准/不赞成审查
59	90	description	6	显示客户菜单
59	91	description	6	显示发票菜单
59	92	description	6	为了显示菜单
59	93	description	6	显示付款和退款菜单
59	94	description	6	显示计费菜单
59	95	description	6	显示调解菜单
59	96	description	6	展会报道菜单
59	97	description	6	显示产品菜单
59	99	description	6	显示配置菜单
59	100	description	6	展会代理菜单
59	101	description	6	创建代理
59	102	description	6	编辑代理
59	103	description	6	删除代理
59	104	description	6	查看代理商的详细信息
59	110	description	6	切换到子账户
59	111	description	6	切换到的任何用户
59	120	description	6	Web服务API访问
59	121	description	6	客户修改结算周期
60	1	description	6	所有的权限的内部用户
60	1	title	6	内部
60	2	description	6	一个实体的超级用户
60	2	title	6	超级用户
60	3	description	6	记帐业务员
60	3	title	6	文员
60	4	description	6	这将为客户带来A剂
60	4	title	6	经纪人
60	5	description	6	一位顾客会询问他/她的帐户
60	5	title	6	顾客
60	6	description	6	一位顾客会询问他/她的帐户
60	6	title	6	顾客
60	7	description	6	一个实体的超级用户
60	7	title	6	超级用户
60	8	description	6	记帐业务员
60	8	title	6	文员
60	9	description	6	一个实体的超级用户
60	9	title	6	超级用户
60	10	description	6	记帐业务员
60	10	title	6	文员
60	11	description	6	一位顾客会询问他/她的帐户
60	11	title	6	顾客
60	12	description	6	一个合作伙伴，将为客户带来
60	12	title	6	经纪人
64	1	description	6	阿富汗
64	2	description	6	阿尔巴尼亚
64	3	description	6	阿尔及利亚
64	4	description	6	美属萨摩亚
64	5	description	6	安道​​尔
64	6	description	6	安哥拉
64	7	description	6	安圭拉
64	8	description	6	南极洲
64	9	description	6	安提瓜和巴布达
64	10	description	6	阿根廷
64	11	description	6	亚美尼亚
64	12	description	6	阿鲁巴岛
64	13	description	6	澳大利亚
64	14	description	6	奥地利
64	15	description	6	阿塞拜疆
64	16	description	6	巴哈马
64	17	description	6	巴林
64	18	description	6	孟加拉国
64	19	description	6	巴巴多斯
64	20	description	6	白俄罗斯
64	21	description	6	比利时
64	22	description	6	伯利兹
64	23	description	6	贝宁
64	24	description	6	百慕大
64	25	description	6	不丹
64	26	description	6	玻利维亚
64	27	description	6	波斯尼亚和黑塞哥维那
64	28	description	6	博茨瓦纳
64	29	description	6	布维岛
64	30	description	6	巴西
64	31	description	6	英属印度洋领地
64	32	description	6	文莱
64	33	description	6	保加利亚
64	34	description	6	布基纳法索
64	40	description	6	开曼群岛
64	41	description	6	中非共和国
64	42	description	6	乍得
64	43	description	6	智利
64	44	description	6	中国
64	45	description	6	圣诞岛
64	46	description	6	科科斯群岛
64	47	description	6	哥伦比亚
64	48	description	6	科摩罗
64	49	description	6	刚果
64	50	description	6	库克群岛
64	51	description	6	哥斯达黎加
64	52	description	6	Cï¿½1ï¿½7te科特迪瓦
64	53	description	6	克罗地亚（赫尔瓦次卡）
64	54	description	6	古巴
64	55	description	6	塞浦路斯
64	56	description	6	捷克共和国
64	57	description	6	刚果（金）
64	58	description	6	丹麦
64	59	description	6	吉布提
64	60	description	6	多米尼加
64	61	description	6	多明尼加共和国
64	62	description	6	东帝汶
64	63	description	6	厄瓜多尔
64	64	description	6	埃及
64	65	description	6	萨尔瓦多
64	66	description	6	赤道几内亚
64	67	description	6	厄立特里亚
64	68	description	6	爱沙尼亚
64	69	description	6	埃塞俄比亚
64	70	description	6	福克兰群岛（马尔维纳斯群岛）
64	71	description	6	法罗群岛
64	72	description	6	斐济群岛
64	73	description	6	芬兰
64	74	description	6	法国
64	75	description	6	法属圭亚那
64	76	description	6	法属波利尼西亚
64	77	description	6	法国南部和南极土地
64	78	description	6	加蓬
64	79	description	6	冈比亚
64	80	description	6	格鲁吉亚
64	81	description	6	德国
64	82	description	6	加纳
64	83	description	6	直布罗陀
64	84	description	6	希腊
64	85	description	6	格陵兰
64	86	description	6	格林纳达
64	87	description	6	瓜德罗普岛
64	88	description	6	关岛
64	89	description	6	危地马拉
64	90	description	6	几内亚
64	91	description	6	几内亚比绍
64	92	description	6	圭亚那
64	93	description	6	海地
64	94	description	6	赫德岛和麦当劳群岛
64	95	description	6	洪都拉斯
64	96	description	6	香港特区
64	97	description	6	匈牙利
64	98	description	6	冰岛
64	99	description	6	印度
64	100	description	6	印度尼西亚
64	101	description	6	伊朗
64	102	description	6	伊拉克
64	104	description	6	以色列
64	105	description	6	意大利
64	106	description	6	牙买加
64	107	description	6	日本
64	108	description	6	约旦
64	109	description	6	哈萨克斯坦
64	110	description	6	肯尼亚
64	111	description	6	基里巴斯
64	112	description	6	韩国
64	113	description	6	科威特
64	114	description	6	吉
64	115	description	6	老挝
64	116	description	6	拉脱维亚
64	117	description	6	黎巴嫩
64	118	description	6	莱索托
64	119	description	6	利比里亚
64	120	description	6	利比亚
64	121	description	6	列支敦士登
64	122	description	6	立陶宛
64	123	description	6	卢森堡
64	124	description	6	澳门特别行政区
64	125	description	6	“马其顿，前南斯拉夫共和国”
64	126	description	6	马达加斯加
64	127	description	6	马拉维
64	128	description	6	马来西亚
64	129	description	6	马尔代夫
64	130	description	6	马里
64	131	description	6	马耳他
64	132	description	6	马绍尔群岛
64	133	description	6	马提尼克
64	134	description	6	毛里塔尼亚
64	135	description	6	毛里求斯
64	136	description	6	马约特
64	137	description	6	墨西哥
64	138	description	6	密克罗尼西亚
64	139	description	6	摩尔多瓦
64	140	description	6	摩纳哥
64	141	description	6	蒙古
64	142	description	6	蒙特塞拉特
64	143	description	6	摩洛哥
64	144	description	6	莫桑比克
64	145	description	6	缅甸
64	146	description	6	纳米比亚
64	147	description	6	瑙鲁
64	148	description	6	尼泊尔
64	149	description	6	荷兰
64	150	description	6	荷属安的列斯
64	151	description	6	新喀里多尼亚
64	152	description	6	新西兰
64	153	description	6	尼加拉瓜
64	154	description	6	尼日尔
64	155	description	6	尼日利亚
64	156	description	6	纽埃
64	157	description	6	诺福克岛
64	158	description	6	北朝鲜
64	159	description	6	北马里亚纳群岛
64	160	description	6	挪威
64	161	description	6	阿曼
64	162	description	6	巴基斯坦
64	163	description	6	帕劳
64	164	description	6	巴拿马
64	165	description	6	巴布亚新几内亚
64	166	description	6	巴拉圭
64	167	description	6	秘鲁
64	168	description	6	菲律宾
64	169	description	6	皮特凯恩群岛
64	170	description	6	波兰
64	171	description	6	葡萄牙
64	172	description	6	波多黎各
64	173	description	6	卡塔尔
64	174	description	6	团圆
64	175	description	6	罗马尼亚
64	176	description	6	俄国
64	177	description	6	卢旺达
64	178	description	6	萨摩亚
64	179	description	6	圣马力诺
64	180	description	6	Sï¿½1ï¿½7oTomï¿½1ï¿½7和Prï¿½1ï¿½7ncipe
64	181	description	6	沙特阿拉伯
64	182	description	6	塞内加尔
64	183	description	6	塞尔维亚和黑山
64	184	description	6	塞舌尔
64	185	description	6	塞拉利昂
64	186	description	6	新加坡
64	187	description	6	斯洛伐克
64	188	description	6	斯洛文尼亚
64	189	description	6	所罗门群岛
64	190	description	6	索马里
64	191	description	6	南非
64	192	description	6	南乔治亚岛和南桑威奇群岛
64	193	description	6	西班牙
64	194	description	6	斯里兰卡
64	195	description	6	圣赫勒拿
64	196	description	6	圣基茨和尼维斯
64	197	description	6	圣卢西亚
64	198	description	6	圣皮埃尔和密克隆
64	199	description	6	圣文森特和格林纳丁斯
64	200	description	6	苏丹
64	201	description	6	苏里南
64	202	description	6	斯瓦尔巴群岛和扬马延
64	203	description	6	斯威士兰
64	204	description	6	瑞典
64	205	description	6	瑞士
64	206	description	6	叙利亚
64	207	description	6	台湾
64	208	description	6	塔吉克斯坦
64	209	description	6	坦桑尼亚
64	210	description	6	泰国
64	211	description	6	多哥
64	212	description	6	托克劳
64	213	description	6	汤加
64	214	description	6	特立尼达和多巴哥
64	215	description	6	突尼斯
64	216	description	6	火鸡
64	217	description	6	土库曼斯坦
64	218	description	6	特克斯和凯科斯群岛
64	219	description	6	图瓦卢
64	220	description	6	乌干达
64	221	description	6	乌克兰
64	222	description	6	阿拉伯联合酋长国
64	223	description	6	英国
64	224	description	6	美国
64	225	description	6	美国本土外小岛屿
64	226	description	6	乌拉圭
64	227	description	6	乌兹别克斯坦
64	228	description	6	瓦努阿图
64	229	description	6	梵蒂冈城
64	230	description	6	委内瑞拉
64	231	description	6	越南
64	232	description	6	维尔京群岛（英国）
64	233	description	6	英属维尔京群岛
64	234	description	6	瓦利斯和富图纳群岛
64	235	description	6	也门
64	236	description	6	赞比亚
64	237	description	6	津巴布韦
69	1	welcome_message	6	“<DIV> <BR/> <p风格=”字体大小：19px;字体重量：大胆;“>！欢迎来到跃马结算</ P> <BR/> <p风格=字体大小： 14px的;文本对齐=左;填充左：15;“>在这里，您可以查看最新发票，并得到它支付的瞬间，您还可以查看所有以前的发票和付款，并建立了系统自动付款。您的信用卡</ p> <p风格=“字体大小：14px的;文本对齐=左;填充左：15;>？请问您今天想做</ P> <UL风格= “字体大小：13px的;文本对齐=左;填充左：25;”> <li>要提交信用卡付款，请在左边栏中的链接</ li> <li>要查看列表。您的发票，用点击A ????Invoicesâ????菜单选项。名单上的第一张发票是最新发票，点击它，看看它的细节。</ li> <li>要查看列表你付款，点击对A ????Paymentsâ????菜单选项。名单上的首付款上一次付款，点击它，看看它的细节。</ li> <li>要提供信用卡卡启用自动付款，点击菜单选项“帐户”，然后在“编辑信用卡”。</ li> </ ul> </ DIV>“
69	2	welcome_message	6	“<DIV> <BR/> <p风格=”字体大小：19px;字体重量：大胆;“>！欢迎来到魔多公司结算</ P> <BR/> <p风格=字体大小：14px的;文本对齐=左;填充左：15;“>在这里，您可以查看最新发票，并得到它支付的瞬间，您还可以查看所有以前的发票和付款，并设置系统自动。 。支付与您的信用卡</ p> <p风格=“字体大小：14px的;文本对齐=左;填充左：15;>？请问您今天想做</ P> <UL风格=“字体大小：13px的;文本对齐=左;填充左：25;”> <li>要提交信用卡付款，请在左边栏中的链接</ li> <li>要查看。发票的列表中，单击在A ????Invoicesâ????菜单选项。名单上的第一张发票是最新发票，点击它，看看它的细节。</ li> <li>要查看付款的列表，单击对A ????Paymentsâ????菜单选项。名单上的首付款上一次付款，点击它，看看它的细节。</ li> <li>要提供信用卡启用自动付款，点击菜单选项“帐户”，然后在“编辑信用卡”。</ li> </ ul> </ DIV>“
73	1	description	6	订购
73	2	description	6	发票
73	3	description	6	付款
73	4	description	6	退款
73	5	description	6	顾客
73	6	description	6	伙伴
73	7	description	6	合作伙伴选择
73	8	description	6	用户
73	9	description	6	项目
81	1	description	6	活性
81	2	description	6	等待退订
81	3	description	6	退订
81	4	description	6	即将到期
81	5	description	6	过期
81	6	description	6	非订户
81	7	description	6	停产
88	1	description	6	活性
88	2	description	6	非活动
88	3	description	6	待活动
88	4	description	6	待无效
88	5	description	6	失败
88	6	description	6	不可用
89	1	description	6	无
89	2	description	6	预付费余额
89	3	description	6	信用额度
90	1	description	6	付费
90	2	description	6	未付
90	3	description	6	携带的
91	1	description	6	完成和计费
91	2	description	6	完成，而不是计费
91	3	description	6	检测到的错误
91	4	description	6	错误申报
92	1	description	6	运行
92	2	description	6	完成：成功
92	3	description	6	表面处理：失败
99	1	description	6	介绍费
99	2	description	6	付款处理器
99	3	description	6	IP地址
100	1	description	6	总金额发票按期间分组。
100	2	description	6	详细余额账龄报告。显示了出色的客户余额岁。
100	3	description	6	用户数量订阅了特定的产品。
100	4	description	6	收到时期分组总付款金额。
100	5	description	6	一段时间内创建的客户数量。
100	6	description	6	每个客户的总收入（收到的付款的总和）。
100	7	description	6	简单的账目显示当前账户余额账款报告。
100	8	description	6	所有发票费用为一天总账细节。
100	9	description	6	“所有的发票费用的某一天，按项目类型分组的总账汇总。”
100	11	description	6	每个客户按产品类别分组共开具发票。
100	12	description	6	每个客户开具发票合计多年来逐年分组。
100	13	description	6	对用户活动中指定天数的声明
101	1	description	6	发票报告
101	2	description	6	订单报告
101	3	description	6	付款报告
101	4	description	6	客户报告
104	1	description	6	发票
104	2	description	6	订单
104	3	description	6	付款
104	4	description	6	用户
104	5	description	6	自定义通知
108	1	description	6	集团成员
108	101	description	6	DefaultStatus
108	102	description	6	AddToOrderStatus
108	103	description	6	Available2
108	104	description	6	无2
111	1	description	6	基
111	2	description	6	基
111	3	description	6	私人
111	4	description	6	商业
111	5	description	6	私人
113	19	errorMessage	6	电子邮件无效
113	37	errorMessage	6	电子邮件无效
113	57	errorMessage	6	电子邮件无效
113	58	errorMessage	6	电子邮件无效
113	71	errorMessage	6	电子邮件无效
113	80	errorMessage	6	电子邮件无效
114	7	errorMessage	6	支付卡号码是无效
114	8	errorMessage	6	到期日期应该是在格式MM / YYYY
114	9	errorMessage	6	ABA路由或银行账号只能是数字
114	10	errorMessage	6	支付卡号码是无效
114	11	errorMessage	6	到期日期应该是在格式MM / YYYY
114	12	errorMessage	6	ABA路由或银行账号只能是数字
114	16	errorMessage	6	密码必须前90天内到期
114	17	errorMessage	6	非活动账户的检查必须做到快超过90天
114	18	errorMessage	6	预约时间应介于0和60万
115	1	description	6	PENDING
115	2	description	6	适用错误
115	3	description	6	应用
114	13	errorMessage	6	到期日期应该是在格式MM / YYYY
114	14	errorMessage	6	支付卡号码是无效
114	15	errorMessage	4	Le numéro de routage ABA ou le numéro de compte bancaire ne peut contenir que des chiffres
114	15	errorMessage	6	ABA路由或银行账号只能是数字
108	100	description	1	IN STOCK
108	101	description	1	DEACTIVE
108	102	description	1	SUBSCRIBED
\.


--
-- Data for Name: invoice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice (id, create_datetime, billing_process_id, user_id, delegated_invoice_id, due_date, total, payment_attempts, status_id, balance, carried_balance, in_process_payment, is_review, currency_id, deleted, paper_invoice_batch_id, customer_notes, public_number, last_reminder, overdue_step, create_timestamp, optlock) FROM stdin;
\.


--
-- Data for Name: invoice_commission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice_commission (id, partner_id, referral_partner_id, commission_process_run_id, invoice_id, standard_amount, master_amount, exception_amount, referral_amount, commission_id) FROM stdin;
\.


--
-- Data for Name: invoice_delivery_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice_delivery_method (id) FROM stdin;
1
2
3
\.


--
-- Data for Name: invoice_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice_line (id, invoice_id, type_id, amount, quantity, price, deleted, item_id, description, source_user_id, is_percentage, optlock, order_id) FROM stdin;
\.


--
-- Data for Name: invoice_line_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice_line_type (id, description, order_position) FROM stdin;
1	item recurring	2
2	tax	6
3	due invoice	1
4	interests	4
5	sub account	5
6	item one-time	3
\.


--
-- Data for Name: invoice_meta_field_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice_meta_field_map (invoice_id, meta_field_value_id) FROM stdin;
\.


--
-- Data for Name: item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item (id, internal_number, entity_id, deleted, has_decimals, optlock, gl_code, price_manual, asset_management_enabled, standard_availability, global, standard_partner_percentage, master_partner_percentage, active_since, active_until, reservation_duration, percentage) FROM stdin;
\.


--
-- Data for Name: item_account_type_availability; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_account_type_availability (item_id, account_type_id) FROM stdin;
\.


--
-- Data for Name: item_dependency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_dependency (id, dtype, item_id, min, max, dependent_item_id, dependent_item_type_id, period) FROM stdin;
\.


--
-- Data for Name: item_entity_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_entity_map (item_id, entity_id) FROM stdin;
\.


--
-- Data for Name: item_meta_field_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_meta_field_map (item_id, meta_field_value_id) FROM stdin;
\.


--
-- Data for Name: item_price; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_price (id, item_id, currency_id, price, optlock, start_date) FROM stdin;
\.


--
-- Data for Name: item_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_type (id, entity_id, description, order_line_type_id, optlock, internal, parent_id, allow_asset_management, asset_identifier_label, global, one_per_order, one_per_customer) FROM stdin;
100	10	plans	1	0	t	\N	0	\N	f	f	f
200	10	Main Subscription	5	1	f	\N	1	ACCOUNT NUMBER	f	f	t
\.


--
-- Data for Name: item_type_entity_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_type_entity_map (item_type_id, entity_id) FROM stdin;
100	10
200	10
\.


--
-- Data for Name: item_type_exclude_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_type_exclude_map (item_id, type_id) FROM stdin;
\.


--
-- Data for Name: item_type_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_type_map (item_id, type_id) FROM stdin;
\.


--
-- Data for Name: item_type_meta_field_def_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_type_meta_field_def_map (item_type_id, meta_field_id) FROM stdin;
\.


--
-- Data for Name: item_type_meta_field_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_type_meta_field_map (item_type_id, meta_field_value_id) FROM stdin;
\.


--
-- Data for Name: jb_host_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jb_host_master (jb_version, jb_allow_signup, jb_git_url, jb_last_git_commit) FROM stdin;
CE-4.1.1  	t	git@github.com:WebDataConsulting/billing.git	\N
\.


--
-- Data for Name: jbilling_seqs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jbilling_seqs (name, next_id) FROM stdin;
entity	2
order_status	2
entity_delivery_method_map	4
contact_field_type	10
user_role_map	13
entity_payment_method_map	26
currency_entity_map	10
order_period	2
billing_process_configuration	2
validation_rule	2
partner_range	1
contact_type	2
ach	1
payment_info_cheque	1
meta_field_name	8
contact_field	1
credit_card	1
subscriber_status	7
balance_type	0
price_model_attribute	0
sure_tax_txn_log_seq	2
discount_attribute	0
period_unit	1
invoice_delivery_method	1
order_line_type	1
ageing_entity_step	1
order_billing_type	1
pluggable_task_type_category	1
order_change_status	3
user_credit_card_map	1
item_price	1
purchase_order	1
user_status	1
invoice_line_type	1
currency	2
report_type	1
payment_method	1
payment_result	1
event_log_module	1
event_log_message	1
preference_type	1
country	3
currency_exchange	1
report	2
billing_process	1
process_run	1
process_run_total	1
order_line	1
invoice	1
invoice_line	1
order_process	1
payment	1
language	1
payment_invoice	1
blacklist	1
promotion	1
partner_payout	1
process_run_total_pm	1
payment_authorization	1
paper_invoice_batch	1
filter	1
filter_set	1
shortcut	1
report_parameter	3
customer	1
partner	1
discount	1
discount_line	1
asset_transition	1
notification_message_type	1
asset	1
data_table_query_entry	1
data_table_query	1
recent_item	1
order_change	1
notification_category	1
item_dependency	1
mediation_process	1
mediation_record_line	1
user_code	1
user_code_link	1
payment_method_template	1
mediation_record	1
payment_information	1
payment_instrument_info	1
customer_notes	1
rating_unit	1
matching_field	1
route	1
order_change_type	1
pluggable_task_type	2
item	1
mediation_cfg	1
contact	2
contact_map	2
role	2
base_user	2
generic_status	39
account_type	2
pluggable_task_parameter	2
pluggable_task	4
preference	2
notification_message	2
notification_message_section	3
notification_message_line	2
enumeration	2
enumeration_values	2
notification_message_arch_line	2
notification_message_arch	2
payment_method_type	2
meta_field_group	3
user_password	2
event_log	8
item_type	3
asset_status	2
breadcrumb	98
\.


--
-- Data for Name: jbilling_table; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jbilling_table (id, name) FROM stdin;
3	language
4	currency
5	entity
6	period_unit
7	invoice_delivery_method
8	entity_delivery_method_map
9	user_status
10	base_user
11	partner
12	customer
13	item_type
14	item
15	item_price
17	order_period
18	order_line_type
19	order_billing_type
20	order_status
21	purchase_order
22	order_line
23	pluggable_task_type_category
24	pluggable_task_type
25	pluggable_task
26	pluggable_task_parameter
27	contact
28	contact_type
29	contact_map
30	invoice_line_type
31	paper_invoice_batch
32	billing_process
33	process_run
34	billing_process_configuration
35	payment_method
36	entity_payment_method_map
37	process_run_total
38	process_run_total_pm
39	invoice
40	invoice_line
41	payment_result
42	payment
43	payment_info_cheque
44	credit_card
45	user_credit_card_map
46	event_log_module
47	event_log_message
48	event_log
49	order_process
50	preference_type
51	preference
52	notification_message_type
53	notification_message
54	notification_message_section
55	notification_message_line
56	notification_message_arch
57	notification_message_arch_line
60	role
62	user_role_map
64	country
65	promotion
66	payment_authorization
67	currency_exchange
68	currency_entity_map
69	ageing_entity_step
70	partner_payout
75	ach
76	contact_field
79	partner_range
80	payment_invoice
81	subscriber_status
85	blacklist
87	generic_status
89	balance_type
90	invoice_status
92	process_run_status
99	contact_field_type
100	report
101	report_type
102	report_parameter
104	notification_category
105	enumeration
106	enumeration_values
107	discount
108	asset_status
109	asset
110	asset_transition
111	account_type
112	meta_field_group
113	meta_field_name
114	validation_rule
1	item_dependency
115	order_change_status
116	order_change
117	order_change_type
118	asset_assignment
82	mediation_cfg
83	mediation_process
86	mediation_record_line
91	mediation_record_status
119	mediation_record
\.


--
-- Data for Name: language; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language (id, code, description) FROM stdin;
1	en	English
2	pt	Portuguese
3	de	Deutsch
4	fr	French
5	hi	Hindi
6	zh	Chinese
\.


--
-- Data for Name: list_meta_field_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.list_meta_field_values (meta_field_value_id, list_value, id) FROM stdin;
\.


--
-- Name: list_meta_field_values_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.list_meta_field_values_id_seq', 1, false);


--
-- Data for Name: matching_field; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matching_field (id, description, required, route_id, matching_field, type, order_sequence, optlock, longest_value, smallest_value, mandatory_fields_query) FROM stdin;
\.


--
-- Data for Name: mediation_cfg; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mediation_cfg (id, entity_id, create_datetime, name, order_value, pluggable_task_id, optlock) FROM stdin;
\.


--
-- Data for Name: mediation_errors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mediation_errors (accountcode, src, dst, dcontext, clid, channel, dstchannel, lastapp, lastdata, start_time, answer, end_time, duration, billsec, disposition, amaflags, userfield, error_message, should_retry) FROM stdin;
\.


--
-- Data for Name: mediation_order_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mediation_order_map (mediation_process_id, order_id) FROM stdin;
\.


--
-- Data for Name: mediation_process; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mediation_process (id, configuration_id, start_datetime, end_datetime, orders_affected, optlock) FROM stdin;
\.


--
-- Data for Name: mediation_record; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mediation_record (id_key, start_datetime, mediation_process_id, optlock, status_id, id) FROM stdin;
\.


--
-- Data for Name: mediation_record_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mediation_record_line (id, order_line_id, event_date, amount, quantity, description, optlock, mediation_record_id) FROM stdin;
\.


--
-- Data for Name: meta_field_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meta_field_group (id, date_created, date_updated, entity_id, display_order, optlock, entity_type, discriminator, name, account_type_id) FROM stdin;
10	2016-11-17	\N	10	1	2	ACCOUNT_TYPE	ACCOUNT_TYPE	Contact	100
11	\N	\N	10	1	0	ACCOUNT_TYPE	ACCOUNT_TYPE	Primary Contact	101
12	\N	\N	10	2	0	ACCOUNT_TYPE	ACCOUNT_TYPE	Shipping Address	101
13	\N	\N	10	3	0	ACCOUNT_TYPE	ACCOUNT_TYPE	Payment Address 	101
14	\N	\N	10	1	0	ACCOUNT_TYPE	ACCOUNT_TYPE	Company Information	102
20	\N	\N	10	2	0	ACCOUNT_TYPE	ACCOUNT_TYPE	Invoicing Address	102
\.


--
-- Data for Name: meta_field_name; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meta_field_name (id, name, entity_type, data_type, is_disabled, is_mandatory, display_order, default_value_id, optlock, entity_id, error_message, is_primary, validation_rule_id, filename, field_usage, is_unique) FROM stdin;
1	cc.cardholder.name	PAYMENT_METHOD_TEMPLATE	STRING	f	t	1	\N	0	10	\N	t	\N	\N	TITLE	f
2	cc.number	PAYMENT_METHOD_TEMPLATE	STRING	f	t	2	\N	0	10	\N	t	10	\N	PAYMENT_CARD_NUMBER	f
3	cc.expiry.date	PAYMENT_METHOD_TEMPLATE	STRING	f	t	3	\N	0	10	\N	t	11	\N	DATE	f
4	cc.gateway.key	PAYMENT_METHOD_TEMPLATE	STRING	t	f	4	\N	0	10	\N	t	\N	\N	GATEWAY_KEY	f
5	cc.type	PAYMENT_METHOD_TEMPLATE	INTEGER	t	f	5	\N	0	10	\N	t	\N	\N	CC_TYPE	f
6	ach.routing.number	PAYMENT_METHOD_TEMPLATE	STRING	f	t	1	\N	0	10	\N	t	12	\N	BANK_ROUTING_NUMBER	f
7	ach.customer.name	PAYMENT_METHOD_TEMPLATE	STRING	f	t	2	\N	0	10	\N	t	\N	\N	TITLE	f
8	ach.account.number	PAYMENT_METHOD_TEMPLATE	STRING	f	t	3	\N	0	10	\N	t	\N	\N	BANK_ACCOUNT_NUMBER	f
9	ach.bank.name	PAYMENT_METHOD_TEMPLATE	STRING	f	t	4	\N	0	10	\N	t	\N	\N	BANK_NAME	f
10	ach.account.type	PAYMENT_METHOD_TEMPLATE	ENUMERATION	f	t	5	\N	0	10	\N	t	\N	\N	BANK_ACCOUNT_TYPE	f
11	ach.gateway.key	PAYMENT_METHOD_TEMPLATE	STRING	t	f	6	\N	0	10	\N	t	\N	\N	GATEWAY_KEY	f
12	cheque.bank.name	PAYMENT_METHOD_TEMPLATE	STRING	f	t	1	\N	0	10	\N	t	\N	\N	BANK_NAME	f
13	cheque.number	PAYMENT_METHOD_TEMPLATE	STRING	f	t	2	\N	0	10	\N	t	\N	\N	CHEQUE_NUMBER	f
14	cheque.date	PAYMENT_METHOD_TEMPLATE	DATE	f	t	3	\N	0	10	\N	t	\N	\N	DATE	f
15	cc.gateway.key	PAYMENT_METHOD_TYPE	STRING	t	f	4	\N	0	10	\N	t	\N	\N	GATEWAY_KEY	f
16	cc.expiry.date	PAYMENT_METHOD_TYPE	STRING	f	t	3	\N	0	10	\N	t	13	\N	DATE	f
17	cc.cardholder.name	PAYMENT_METHOD_TYPE	STRING	f	t	1	\N	0	10	\N	t	\N	\N	TITLE	f
18	cc.type	PAYMENT_METHOD_TYPE	INTEGER	t	f	5	\N	0	10	\N	t	\N	\N	CC_TYPE	f
19	cc.number	PAYMENT_METHOD_TYPE	STRING	f	t	2	\N	0	10	\N	t	14	\N	PAYMENT_CARD_NUMBER	f
20	cheque.date	PAYMENT_METHOD_TYPE	DATE	f	t	3	\N	0	10	\N	t	\N	\N	DATE	f
21	cheque.bank.name	PAYMENT_METHOD_TYPE	STRING	f	t	1	\N	0	10	\N	t	\N	\N	BANK_NAME	f
22	cheque.number	PAYMENT_METHOD_TYPE	STRING	f	t	2	\N	0	10	\N	t	\N	\N	CHEQUE_NUMBER	f
23	ach.account.number	PAYMENT_METHOD_TYPE	STRING	f	t	3	\N	0	10	\N	t	\N	\N	BANK_ACCOUNT_NUMBER	f
24	ach.bank.name	PAYMENT_METHOD_TYPE	STRING	f	t	4	\N	0	10	\N	t	\N	\N	BANK_NAME	f
25	ach.account.type	PAYMENT_METHOD_TYPE	ENUMERATION	f	t	5	\N	0	10	\N	t	\N	\N	BANK_ACCOUNT_TYPE	f
26	ach.customer.name	PAYMENT_METHOD_TYPE	STRING	f	t	2	\N	0	10	\N	t	\N	\N	TITLE	f
27	ach.routing.number	PAYMENT_METHOD_TYPE	STRING	f	t	1	\N	0	10	\N	t	15	\N	BANK_ROUTING_NUMBER	f
28	ach.gateway.key	PAYMENT_METHOD_TYPE	STRING	t	f	6	\N	0	10	\N	t	\N	\N	GATEWAY_KEY	f
29	contact.email	ACCOUNT_TYPE	STRING	f	t	1	\N	0	10	\N	f	16		EMAIL	f
30	contact.address1	ACCOUNT_TYPE	STRING	f	f	3	\N	0	10	\N	f	\N		ADDRESS1	f
31	contact.postal.code	ACCOUNT_TYPE	STRING	f	f	7	\N	0	10	\N	f	\N		POSTAL_CODE	f
32	contact.state.province	ACCOUNT_TYPE	STRING	f	f	6	\N	0	10	\N	f	\N		STATE_PROVINCE	f
33	contact.organization	ACCOUNT_TYPE	STRING	f	f	2	\N	0	10	\N	f	\N		ORGANIZATION	f
34	contact.country.code	ACCOUNT_TYPE	STRING	f	f	8	\N	0	10	\N	f	\N		COUNTRY_CODE	f
35	contact.address2	ACCOUNT_TYPE	STRING	f	f	4	\N	0	10	\N	f	\N		ADDRESS2	f
36	contact.city	ACCOUNT_TYPE	STRING	f	f	5	\N	0	10	\N	f	\N		CITY	f
37	contact.initial	ACCOUNT_TYPE	STRING	f	f	11	\N	0	10	\N	f	\N		INITIAL	f
38	contact.fax.area.code	ACCOUNT_TYPE	STRING	f	f	17	\N	0	10	\N	f	\N		FAX_AREA_CODE	f
39	contact.last.name	ACCOUNT_TYPE	STRING	f	f	10	\N	0	10	\N	f	\N		LAST_NAME	f
40	contact.fax.country.code	ACCOUNT_TYPE	INTEGER	f	f	16	\N	0	10	\N	f	\N		FAX_COUNTRY_CODE	f
41	contact.first.name	ACCOUNT_TYPE	STRING	f	f	9	\N	0	10	\N	f	\N		FIRST_NAME	f
42	contact.title	ACCOUNT_TYPE	STRING	f	f	12	\N	0	10	\N	f	\N		TITLE	f
43	contact.phone.country.code	ACCOUNT_TYPE	INTEGER	f	f	13	\N	0	10	\N	f	\N		PHONE_COUNTRY_CODE	f
44	contact.phone.number	ACCOUNT_TYPE	STRING	f	f	15	\N	0	10	\N	f	\N		PHONE_NUMBER	f
45	contact.phone.area.code	ACCOUNT_TYPE	INTEGER	f	f	14	\N	0	10	\N	f	\N		PHONE_AREA_CODE	f
46	contact.fax.number	ACCOUNT_TYPE	STRING	f	f	18	\N	0	10	\N	f	\N		FAX_NUMBER	f
47	contact.email	ACCOUNT_TYPE	STRING	f	t	3	\N	0	10	\N	f	17		EMAIL	f
48	last.name	ACCOUNT_TYPE	STRING	f	t	2	\N	0	10	\N	f	\N		LAST_NAME	f
49	first.name	ACCOUNT_TYPE	STRING	f	t	1	\N	0	10	\N	f	\N		FIRST_NAME	f
50	contact.tax.id	ACCOUNT_TYPE	INTEGER	f	f	5	\N	0	10	\N	f	\N		ORGANIZATION	f
51	contact.address1	ACCOUNT_TYPE	STRING	f	t	1	\N	0	10	\N	f	\N		ADDRESS1	f
52	contact.city	ACCOUNT_TYPE	STRING	f	t	2	\N	0	10	\N	f	\N		CITY	f
53	contact.state.province	ACCOUNT_TYPE	STRING	f	f	3	\N	0	10	\N	f	\N		STATE_PROVINCE	f
54	contact.postal.code	ACCOUNT_TYPE	STRING	f	t	4	\N	0	10	\N	f	\N		POSTAL_CODE	f
55	contact.country.code	ACCOUNT_TYPE	STRING	f	f	5	\N	0	10	\N	f	\N		COUNTRY_CODE	f
56	contact.country.code	ACCOUNT_TYPE	STRING	f	f	5	\N	0	10	\N	f	\N		COUNTRY_CODE	f
57	contact.state.province	ACCOUNT_TYPE	STRING	f	f	2	\N	0	10	\N	f	\N		STATE_PROVINCE	f
58	contact.city	ACCOUNT_TYPE	STRING	f	t	1	\N	0	10	\N	f	\N		CITY	f
59	contact.postal.code	ACCOUNT_TYPE	STRING	f	f	4	\N	0	10	\N	f	\N		POSTAL_CODE	f
60	contact.address1	ACCOUNT_TYPE	STRING	f	f	4	\N	0	10	\N	f	\N		ADDRESS1	f
61	contact.organization	ACCOUNT_TYPE	STRING	f	t	1	\N	0	10	\N	f	\N		ORGANIZATION	f
62	contact.email	ACCOUNT_TYPE	STRING	f	t	1	\N	0	10	\N	f	18		EMAIL	f
70	contact.city	ACCOUNT_TYPE	STRING	f	t	2	\N	0	10	\N	f	\N		CITY	f
71	contact.state.province	ACCOUNT_TYPE	STRING	f	f	3	\N	0	10	\N	f	\N		STATE_PROVINCE	f
72	contact.postal.code	ACCOUNT_TYPE	STRING	f	t	4	\N	0	10	\N	f	\N		POSTAL_CODE	f
73	contact.country.code	ACCOUNT_TYPE	STRING	f	f	5	\N	0	10	\N	f	\N		COUNTRY_CODE	f
74	contact.address1	ACCOUNT_TYPE	STRING	f	t	1	\N	0	10	\N	f	\N		ADDRESS1	f
\.


--
-- Data for Name: meta_field_value; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meta_field_value (id, meta_field_name_id, dtype, boolean_value, date_value, decimal_value, integer_value, string_value) FROM stdin;
\.


--
-- Data for Name: metafield_group_meta_field_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metafield_group_meta_field_map (metafield_group_id, meta_field_value_id) FROM stdin;
10	35
10	34
10	30
10	32
10	36
10	31
10	39
10	41
10	42
10	44
10	29
10	40
10	45
10	37
10	46
10	38
10	43
10	33
11	48
11	50
11	47
11	49
12	51
12	54
12	52
12	55
12	53
13	57
13	59
13	60
13	58
13	56
14	62
14	61
20	71
20	73
20	70
20	72
20	74
\.


--
-- Data for Name: notification_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_category (id) FROM stdin;
1
2
3
4
5
\.


--
-- Data for Name: notification_medium_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_medium_type (notification_id, medium_type) FROM stdin;
1	SMS
1	EMAIL
1	PDF
2	SMS
2	EMAIL
2	PDF
3	SMS
3	EMAIL
3	PDF
4	SMS
4	EMAIL
4	PDF
7	SMS
7	EMAIL
7	PDF
8	SMS
8	EMAIL
8	PDF
9	SMS
9	EMAIL
9	PDF
10	SMS
10	EMAIL
10	PDF
11	SMS
11	EMAIL
11	PDF
12	SMS
12	EMAIL
12	PDF
13	SMS
13	EMAIL
13	PDF
14	SMS
14	EMAIL
14	PDF
15	SMS
15	EMAIL
15	PDF
17	SMS
17	EMAIL
17	PDF
18	SMS
18	EMAIL
18	PDF
19	SMS
19	EMAIL
19	PDF
16	SMS
16	EMAIL
16	PDF
20	SMS
20	EMAIL
20	PDF
21	SMS
21	EMAIL
21	PDF
22	SMS
22	EMAIL
22	PDF
23	SMS
23	EMAIL
23	PDF
24	SMS
24	EMAIL
24	PDF
25	SMS
25	EMAIL
25	PDF
26	SMS
26	EMAIL
26	PDF
27	SMS
27	EMAIL
27	PDF
28	SMS
28	EMAIL
28	PDF
29	SMS
29	EMAIL
29	PDF
30	SMS
30	EMAIL
30	PDF
31	SMS
31	EMAIL
31	PDF
32	SMS
32	EMAIL
32	PDF
33	SMS
33	EMAIL
33	PDF
34	SMS
34	EMAIL
34	PDF
35	SMS
35	EMAIL
35	PDF
36	SMS
36	EMAIL
36	PDF
100	EMAIL
100	SMS
100	PDF
101	EMAIL
101	SMS
101	PDF
102	EMAIL
102	SMS
102	PDF
103	EMAIL
103	SMS
103	PDF
104	EMAIL
104	SMS
104	PDF
105	EMAIL
105	SMS
105	PDF
106	EMAIL
106	SMS
106	PDF
107	EMAIL
107	SMS
107	PDF
108	EMAIL
108	SMS
108	PDF
109	EMAIL
109	SMS
109	PDF
\.


--
-- Data for Name: notification_message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_message (id, type_id, entity_id, language_id, use_flag, optlock, attachment_type, include_attachment, attachment_design, notify_admin, notify_partner, notify_parent, notify_all_parents) FROM stdin;
100	1	10	1	1	2	\N	\N	\N	0	0	0	0
101	2	10	1	1	1	\N	\N	\N	0	0	0	0
102	3	10	1	1	1	\N	\N	\N	0	0	0	0
103	13	10	1	1	1	\N	\N	\N	0	0	0	0
104	16	10	1	1	1	\N	\N	\N	0	0	0	0
105	17	10	1	1	1	\N	\N	\N	0	0	0	0
106	18	10	1	1	1	\N	\N	\N	0	0	0	0
107	19	10	1	1	1	\N	\N	\N	0	0	0	0
108	20	10	1	1	1	\N	\N	\N	0	0	0	0
109	21	10	1	1	1	\N	\N	\N	0	0	0	0
\.


--
-- Data for Name: notification_message_arch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_message_arch (id, type_id, create_datetime, user_id, result_message, optlock) FROM stdin;
100	21	2016-11-13 21:49:51.521	10	Exception sending the message.Mail server connection failed; nested exception is javax.mail.MessagingException: Connection error (java.net.ConnectException: Connection refused). Failed messages: javax	1
101	21	2016-11-13 21:49:51.884	10	\N	1
102	21	2016-11-13 21:49:51.887	10	\N	1
\.


--
-- Data for Name: notification_message_arch_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_message_arch_line (id, message_archive_id, section, content, optlock) FROM stdin;
100	100	1	Initial Credentials	1
101	100	2	Hello Rakesh Sahadevan,\n\nWelcome to jBilling!.\n\nPlease follow this link to set your credentials:\n\nhttp://www.yourcompany.com/jbilling/resetPassword/changePassword?token=Mdc3WF2UMpsNddhggbfaDUENAmoAD7pN\n\nAdmin:\tngecom	1
102	101	1	Initial Credentials	1
103	101	2	Hello Rakesh Sahadevan,\n\nWelcome to jBilling!.\n\nPlease follow this link to set your credentials:\n\nhttp://www.yourcompany.com/jbilling/resetPassword/changePassword?token=Mdc3WF2UMpsNddhggbfaDUENAmoAD7pN\n\nAdmin:\tngecom	1
104	102	1	Initial Credentials	1
105	102	2	Hello Rakesh Sahadevan,\n\nWelcome to jBilling!.\n\nPlease follow this link to set your credentials:\n\nhttp://www.yourcompany.com/jbilling/resetPassword/changePassword?token=Mdc3WF2UMpsNddhggbfaDUENAmoAD7pN\n\nAdmin:\tngecom	1
\.


--
-- Data for Name: notification_message_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_message_line (id, message_section_id, content, optlock) FROM stdin;
1	1	Usage pool consumption status.	0
2	2	Dear $userSalutation,\\r\\n\\r\\nYou have used $percentageConsumption% from Free Usage Pool - $usagePoolName.\\r\\n\\r\\nThanks.	0
100	200	Billing Statement from $company_name	0
101	101	Dear $first_name $last_name,\n\n This is to notify you that your latest invoice (number $number) is now available. The total amount due is: $total. You can view it by login in to:\n\n" + Util.getSysProp("url") + "/billing/user/login.jsp?entityId=$company_id\n\nFor security reasons, your statement is password protected.\nTo login in, you will need your user name: $username and your account password: $password\n \n After logging in, please click on the menu option  ï¿½Listï¿½, to see all your invoices.  You can also see your payment history, your current purchase orders, as well as update your payment information and submit online payments.\n\n\nThank you for choosing $company_name, we appreciate your business,\n\nBilling Department\n$company_name	0
102	102	You account is now up to date	0
103	103	Dear $first_name $last_name,\n\n  This email is to notify you that we have received your latest payment and your account no longer has an overdue balance.\n\n  Thank you for keeping your account up to date,\n\n\nBilling Department\n$company_name	0
104	104	Overdue Balance	0
105	105	Dear $first_name $last_name,\n\nOur records show that you have an overdue balance on your account. Please submit a payment as soon as possible.\n\nBest regards,\n\nBilling Department\n$company_name	0
106	106	Your service from $company_name is about to expire	0
107	107	Dear $first_name $last_name,\n\nYour service with us will expire on $period_end. Please make sure to contact customer service for a renewal.\n\nRegards,\n\nBilling Department\n$company_name	0
108	108	Thank you for your payment	0
109	109	Dear $first_name $last_name\n\n   We have received your payment made with $method for a total of $total.\n\n   Thank you, we appreciate your business,\n\nBilling Department\n$company_name	0
110	110	Payment failed	0
111	111	Dear $first_name $last_name\n\n   A payment with $method was attempted for a total of $total, but it has been rejected by the payment processor.\nYou can update your payment information and submit an online payment by login into :\n" + Util.getSysProp("url") + "/billing/user/login.jsp?entityId=$company_id\n\nFor security reasons, your statement is password protected.\nTo login in, you will need your user name: $username and your account password: $password\n\nThank you,\n\nBilling Department\n$company_name	0
112	112	Invoice reminder	0
113	113	Dear $first_name $last_name\n\n   This is a reminder that the invoice number $number remains unpaid. It was sent to you on $date, and its total is $total. Although you still have $days days to pay it (its due date is $dueDate), we would greatly appreciate if you can pay it at your earliest convenience.\n\nYours truly,\n\nBilling Department\n$company_name	0
114	114	It is time to update your credit card	0
115	115	Dear $first_name $last_name,\n\nWe want to remind you that the credit card that we have in our records for your account is about to expire. Its expiration date is $expiry_date.\n\nUpdating your credit card is easy. Just login into " + Util.getSysProp("url") + "/billing/user/login.jsp?entityId=$company_id. using your user name: $username and password: $password. After logging in, click on 'Account' and then 'Edit Credit Card'. \nThank you for keeping your account up to date.\n\nBilling Department\n$company_name	0
116	116	Reset password request	0
117	117	Hello  $first_name $last_name,\n\nYou (or someone pretending to be you) requested a password reset of your account.\n\nYou may reset your password from the following link:\n\n$newPasswordLink\n\nAdmin:\t$organization_name	0
118	118	Initial Credentials	0
119	119	Hello $first_name $last_name,\n\nWelcome to jBilling!.\n\nPlease follow this link to set your credentials:\n\n$newPasswordLink\n\nAdmin:\t$organization_name	0
\.


--
-- Data for Name: notification_message_section; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_message_section (id, message_id, section, optlock) FROM stdin;
1	\N	1	0
2	\N	2	0
3	\N	3	0
200	100	1	0
100	100	1	0
101	100	2	0
102	101	1	0
103	101	2	0
104	102	1	0
105	102	2	0
106	103	1	0
107	103	2	0
108	104	1	0
109	104	2	0
110	105	1	0
111	105	2	0
112	106	1	0
113	106	2	0
114	107	1	0
115	107	2	0
116	108	1	0
117	108	2	0
118	109	1	0
119	109	2	0
\.


--
-- Data for Name: notification_message_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_message_type (id, optlock, category_id) FROM stdin;
1	1	1
2	1	4
3	1	4
4	1	4
5	1	4
6	1	4
7	1	4
8	1	4
9	1	4
12	1	1
13	1	2
14	1	2
15	1	2
16	1	3
17	1	3
18	1	1
19	1	4
20	1	4
22	1	3
23	1	3
24	0	5
25	0	4
26	0	4
27	0	4
21	0	4
\.


--
-- Data for Name: order_billing_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_billing_type (id) FROM stdin;
1
2
\.


--
-- Data for Name: order_change; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change (id, parent_order_change_id, parent_order_line_id, order_id, item_id, quantity, price, description, use_item, user_id, create_datetime, start_date, application_date, status_id, user_assigned_status_id, order_line_id, optlock, error_message, error_codes, applied_manually, removal, next_billable_date, end_date, order_change_type_id, order_status_id, is_percentage) FROM stdin;
\.


--
-- Data for Name: order_change_asset_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change_asset_map (order_change_id, asset_id) FROM stdin;
\.


--
-- Data for Name: order_change_meta_field_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change_meta_field_map (order_change_id, meta_field_value_id) FROM stdin;
\.


--
-- Data for Name: order_change_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change_type (id, name, entity_id, default_type, allow_order_status_change, optlock) FROM stdin;
1	Default	\N	t	f	0
\.


--
-- Data for Name: order_change_type_item_type_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change_type_item_type_map (order_change_type_id, item_type_id) FROM stdin;
\.


--
-- Data for Name: order_change_type_meta_field_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change_type_meta_field_map (order_change_type_id, meta_field_id) FROM stdin;
\.


--
-- Data for Name: order_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line (id, order_id, item_id, type_id, amount, quantity, price, item_price, create_datetime, deleted, description, optlock, use_item, parent_line_id, start_date, end_date, sip_uri, is_percentage) FROM stdin;
\.


--
-- Data for Name: order_line_meta_field_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_meta_field_map (order_line_id, meta_field_value_id) FROM stdin;
\.


--
-- Data for Name: order_line_meta_fields_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_meta_fields_map (item_id, meta_field_id) FROM stdin;
\.


--
-- Data for Name: order_line_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_type (id, editable) FROM stdin;
1	1
2	0
3	0
4	0
5	1
6	1
\.


--
-- Data for Name: order_meta_field_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_meta_field_map (order_id, meta_field_value_id) FROM stdin;
\.


--
-- Data for Name: order_period; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_period (id, entity_id, value, unit_id, optlock) FROM stdin;
5	\N	\N	\N	1
1	\N	\N	\N	1
100	10	1	1	0
\.


--
-- Data for Name: order_process; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_process (id, order_id, invoice_id, billing_process_id, periods_included, period_start, period_end, is_review, origin, optlock) FROM stdin;
\.


--
-- Data for Name: order_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_status (id, order_status_flag, entity_id) FROM stdin;
100	0	10
101	1	10
102	2	10
103	3	10
\.


--
-- Data for Name: paper_invoice_batch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paper_invoice_batch (id, total_invoices, delivery_date, is_self_managed, optlock) FROM stdin;
\.


--
-- Data for Name: partner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.partner (id, user_id, total_payments, total_refunds, total_payouts, due_payout, optlock, type, parent_id, commission_type) FROM stdin;
\.


--
-- Data for Name: partner_commission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.partner_commission (id, amount, type, partner_id, commission_process_run_id, currency_id) FROM stdin;
\.


--
-- Data for Name: partner_commission_exception; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.partner_commission_exception (id, partner_id, start_date, end_date, percentage, item_id) FROM stdin;
\.


--
-- Data for Name: partner_commission_proc_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.partner_commission_proc_config (id, entity_id, next_run_date, period_unit_id, period_value) FROM stdin;
\.


--
-- Data for Name: partner_commission_process_run; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.partner_commission_process_run (id, run_date, period_start, period_end, entity_id) FROM stdin;
\.


--
-- Data for Name: partner_meta_field_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.partner_meta_field_map (partner_id, meta_field_value_id) FROM stdin;
\.


--
-- Data for Name: partner_payout; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.partner_payout (id, starting_date, ending_date, payments_amount, refunds_amount, balance_left, payment_id, partner_id, optlock) FROM stdin;
\.


--
-- Data for Name: partner_referral_commission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.partner_referral_commission (id, referral_id, referrer_id, start_date, end_date, percentage) FROM stdin;
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (id, user_id, attempt, result_id, amount, create_datetime, update_datetime, payment_date, method_id, credit_card_id, deleted, is_refund, is_preauth, payment_id, currency_id, payout_id, ach_id, balance, optlock, payment_period, payment_notes) FROM stdin;
\.


--
-- Data for Name: payment_authorization; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_authorization (id, payment_id, processor, code1, code2, code3, approval_code, avs, transaction_id, md5, card_code, create_datetime, response_message, optlock) FROM stdin;
\.


--
-- Data for Name: payment_commission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_commission (id, invoice_id, payment_amount) FROM stdin;
\.


--
-- Data for Name: payment_info_cheque; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_info_cheque (id, payment_id, bank, cheque_number, cheque_date, optlock) FROM stdin;
\.


--
-- Data for Name: payment_information; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_information (id, user_id, payment_method_id, processing_order, deleted, optlock) FROM stdin;
\.


--
-- Data for Name: payment_information_meta_fields_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_information_meta_fields_map (payment_information_id, meta_field_value_id) FROM stdin;
\.


--
-- Data for Name: payment_instrument_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_instrument_info (id, result_id, method_id, instrument_id, payment_id) FROM stdin;
\.


--
-- Data for Name: payment_invoice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_invoice (id, payment_id, invoice_id, amount, create_datetime, optlock) FROM stdin;
\.


--
-- Data for Name: payment_meta_field_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_meta_field_map (payment_id, meta_field_value_id) FROM stdin;
\.


--
-- Data for Name: payment_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_method (id) FROM stdin;
1
2
3
4
5
6
7
8
9
15
\.


--
-- Data for Name: payment_method_account_type_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_method_account_type_map (payment_method_id, account_type_id) FROM stdin;
12	100
10	100
11	100
12	101
11	101
10	101
10	102
12	102
11	102
\.


--
-- Data for Name: payment_method_meta_fields_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_method_meta_fields_map (payment_method_id, meta_field_id) FROM stdin;
10	17
10	16
10	19
10	15
10	18
11	20
11	21
11	22
12	23
12	25
12	26
12	27
12	24
12	28
\.


--
-- Data for Name: payment_method_template; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_method_template (id, template_name, optlock) FROM stdin;
1	Payment Card	2
2	ACH	3
3	Cheque	1
\.


--
-- Data for Name: payment_method_template_meta_fields_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_method_template_meta_fields_map (method_template_id, meta_field_id) FROM stdin;
1	1
1	2
1	3
1	4
1	5
2	6
2	7
2	8
2	9
2	10
2	11
3	12
3	13
3	14
\.


--
-- Data for Name: payment_method_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_method_type (id, method_name, is_recurring, entity_id, template_id, optlock, all_account_type) FROM stdin;
11	Cheque	f	10	3	1	f
12	ACH	t	10	2	1	f
10	Credit Card	t	10	1	2	f
\.


--
-- Data for Name: payment_result; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_result (id) FROM stdin;
1
2
3
4
\.


--
-- Data for Name: period_unit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.period_unit (id) FROM stdin;
1
2
3
4
5
\.


--
-- Data for Name: pluggable_task; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pluggable_task (id, entity_id, type_id, processing_order, optlock, notes) FROM stdin;
10	10	21	1	0	\N
11	10	9	1	0	\N
12	10	12	2	0	\N
13	10	1	1	0	\N
14	10	3	1	0	\N
15	10	4	2	0	\N
16	10	5	1	0	\N
17	10	6	1	0	\N
18	10	7	1	0	\N
19	10	10	1	0	\N
20	10	25	1	0	\N
21	10	28	1	0	\N
22	10	54	1	0	\N
23	10	82	1	0	\N
24	10	88	2	0	\N
25	10	87	1	0	\N
26	10	69	1	0	\N
27	10	114	2	0	\N
28	10	115	3	0	\N
29	10	125	7	0	\N
30	10	36	3	0	\N
\.


--
-- Data for Name: pluggable_task_parameter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pluggable_task_parameter (id, task_id, name, int_value, str_value, float_value, optlock) FROM stdin;
100	10	all	\N	yes	\N	0
101	11	smtp_server	\N		\N	1
102	11	port	\N		\N	1
103	11	ssl_auth	\N	false	\N	1
104	11	tls	\N	false	\N	1
105	11	username	\N		\N	1
106	11	password	\N		\N	1
107	12	design	\N	simple_invoice_b2b	\N	1
108	30	from	\N	admin@jbilling.com	\N	1
\.


--
-- Data for Name: pluggable_task_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pluggable_task_type (id, category_id, class_name, min_parameters) FROM stdin;
1	1	com.sapienter.jbilling.server.pluggableTask.BasicLineTotalTask	0
13	4	com.sapienter.jbilling.server.pluggableTask.CalculateDueDateDfFm	0
3	4	com.sapienter.jbilling.server.pluggableTask.CalculateDueDate	0
4	4	com.sapienter.jbilling.server.pluggableTask.BasicCompositionTask	0
5	2	com.sapienter.jbilling.server.pluggableTask.BasicOrderFilterTask	0
6	3	com.sapienter.jbilling.server.pluggableTask.BasicInvoiceFilterTask	0
7	5	com.sapienter.jbilling.server.pluggableTask.BasicOrderPeriodTask	0
8	6	com.sapienter.jbilling.server.pluggableTask.PaymentAuthorizeNetTask	2
14	3	com.sapienter.jbilling.server.pluggableTask.NoInvoiceFilterTask	0
10	8	com.sapienter.jbilling.server.pluggableTask.BasicPaymentInfoTask	0
11	6	com.sapienter.jbilling.server.pluggableTask.PaymentPartnerTestTask	0
12	7	com.sapienter.jbilling.server.pluggableTask.PaperInvoiceNotificationTask	1
2	1	com.sapienter.jbilling.server.pluggableTask.GSTTaxTask	2
16	2	com.sapienter.jbilling.server.pluggableTask.OrderFilterAnticipatedTask	0
9	7	com.sapienter.jbilling.server.pluggableTask.BasicEmailNotificationTask	6
17	5	com.sapienter.jbilling.server.pluggableTask.OrderPeriodAnticipateTask	0
19	6	com.sapienter.jbilling.server.pluggableTask.PaymentEmailAuthorizeNetTask	1
20	10	com.sapienter.jbilling.server.pluggableTask.ProcessorEmailAlarmTask	3
21	6	com.sapienter.jbilling.server.pluggableTask.PaymentFakeTask	0
22	6	com.sapienter.jbilling.server.payment.tasks.PaymentRouterCCFTask	2
23	11	com.sapienter.jbilling.server.user.tasks.BasicSubscriptionStatusManagerTask	0
24	6	com.sapienter.jbilling.server.user.tasks.PaymentACHCommerceTask	5
25	12	com.sapienter.jbilling.server.payment.tasks.NoAsyncParameters	0
26	12	com.sapienter.jbilling.server.payment.tasks.RouterAsyncParameters	0
28	13	com.sapienter.jbilling.server.item.tasks.BasicItemManager	0
29	13	com.sapienter.jbilling.server.item.tasks.RulesItemManager	0
30	1	com.sapienter.jbilling.server.order.task.RulesLineTotalTask	0
31	14	com.sapienter.jbilling.server.item.tasks.RulesPricingTask	0
35	8	com.sapienter.jbilling.server.user.tasks.PaymentInfoNoValidateTask	0
36	7	com.sapienter.jbilling.server.notification.task.TestNotificationTask	0
39	6	com.sapienter.jbilling.server.payment.tasks.PaymentAtlasTask	5
40	17	com.sapienter.jbilling.server.order.task.RefundOnCancelTask	0
41	17	com.sapienter.jbilling.server.order.task.CancellationFeeRulesTask	1
42	6	com.sapienter.jbilling.server.payment.tasks.PaymentFilterTask	0
43	17	com.sapienter.jbilling.server.payment.blacklist.tasks.BlacklistUserStatusTask	0
49	6	com.sapienter.jbilling.server.payment.tasks.PaymentRouterCurrencyTask	2
51	3	com.sapienter.jbilling.server.invoice.task.NegativeBalanceInvoiceFilterTask	0
52	17	com.sapienter.jbilling.server.invoice.task.FileInvoiceExportTask	1
53	17	com.sapienter.jbilling.server.system.event.task.InternalEventsRulesTask	0
54	17	com.sapienter.jbilling.server.user.balance.DynamicBalanceManagerTask	0
55	19	com.sapienter.jbilling.server.user.tasks.UserBalanceValidatePurchaseTask	0
56	19	com.sapienter.jbilling.server.user.tasks.RulesValidatePurchaseTask	0
57	6	com.sapienter.jbilling.server.payment.tasks.PaymentsGatewayTask	4
58	17	com.sapienter.jbilling.server.payment.tasks.SaveCreditCardExternallyTask	1
59	13	com.sapienter.jbilling.server.order.task.RulesItemManager2	0
60	1	com.sapienter.jbilling.server.order.task.RulesLineTotalTask2	0
61	14	com.sapienter.jbilling.server.item.tasks.RulesPricingTask2	0
62	17	com.sapienter.jbilling.server.payment.tasks.SaveCreditCardExternallyTask	1
63	6	com.sapienter.jbilling.server.pluggableTask.PaymentFakeExternalStorage	0
64	6	com.sapienter.jbilling.server.payment.tasks.PaymentWorldPayTask	3
65	6	com.sapienter.jbilling.server.payment.tasks.PaymentWorldPayExternalTask	3
66	17	com.sapienter.jbilling.server.user.tasks.AutoRechargeTask	0
67	6	com.sapienter.jbilling.server.payment.tasks.PaymentBeanstreamTask	3
68	6	com.sapienter.jbilling.server.payment.tasks.PaymentSageTask	2
69	20	com.sapienter.jbilling.server.process.task.BasicBillingProcessFilterTask	0
70	20	com.sapienter.jbilling.server.process.task.BillableUsersBillingProcessFilterTask	0
75	6	com.sapienter.jbilling.server.payment.tasks.PaymentPaypalExternalTask	3
76	6	com.sapienter.jbilling.server.payment.tasks.PaymentAuthorizeNetCIMTask	2
77	6	com.sapienter.jbilling.server.payment.tasks.PaymentMethodRouterTask	4
82	22	com.sapienter.jbilling.server.billing.task.BillingProcessTask	0
83	22	com.sapienter.jbilling.server.process.task.ScpUploadTask	4
84	17	com.sapienter.jbilling.server.payment.tasks.SaveACHExternallyTask	1
85	20	com.sapienter.jbilling.server.process.task.BillableUserOrdersBillingProcessFilterTask	0
87	24	com.sapienter.jbilling.server.process.task.BasicAgeingTask	0
88	22	com.sapienter.jbilling.server.process.task.AgeingProcessTask	0
89	24	com.sapienter.jbilling.server.process.task.BusinessDayAgeingTask	0
91	4	com.sapienter.jbilling.server.process.task.CountryTaxCompositionTask	2
92	4	com.sapienter.jbilling.server.process.task.PaymentTermPenaltyTask	2
15	17	com.sapienter.jbilling.server.pluggableTask.BasicPenaltyTask	1
90	4	com.sapienter.jbilling.server.process.task.SimpleTaxCompositionTask	1
97	17	com.sapienter.jbilling.server.pluggableTask.OverdueInvoicePenaltyTask	1
105	4	com.sapienter.jbilling.server.process.task.SureTaxCompositionTask	0
106	17	com.sapienter.jbilling.server.process.task.SuretaxDeleteInvoiceTask	0
107	17	com.sapienter.jbilling.server.invoice.task.ApplyNegativeInvoiceToPaymentTask	0
108	17	com.sapienter.jbilling.server.user.tasks.BalanceThresholdNotificationTask	1
109	17	com.sapienter.jbilling.server.user.tasks.UserAgeingNotificationTask	0
110	22	com.sapienter.jbilling.server.pluggableTask.FileCleanupTask	2
111	17	com.sapienter.jbilling.server.item.tasks.AssetUpdatedTask	0
112	17	com.sapienter.jbilling.server.item.tasks.RemoveAssetFromFinishedOrderTask	0
113	17	com.sapienter.jbilling.server.order.task.OrderCancellationTask	1
114	17	com.sapienter.jbilling.server.order.task.CreateOrderForResellerTask	0
115	17	com.sapienter.jbilling.server.invoice.task.DeleteResellerOrderTask	0
116	22	com.sapienter.jbilling.server.order.task.OrderChangeUpdateTask	0
117	22	com.sapienter.jbilling.server.user.partner.task.CalculateCommissionTask	0
118	25	com.sapienter.jbilling.server.user.partner.task.BasicPartnerCommissionTask	0
119	17	com.sapienter.jbilling.server.payment.tasks.GeneratePaymentCommissionTask	0
120	26	com.sapienter.jbilling.server.process.task.FtpRemoteCopyTask	0
121	26	com.sapienter.jbilling.server.process.task.FtpsRemoteCopyTask	0
122	26	com.sapienter.jbilling.server.process.task.StpRemoteCopyTask	0
123	22	com.sapienter.jbilling.server.process.task.FileExchangeTriggerTask	1
124	17	com.sapienter.jbilling.server.user.tasks.CreditLimitationNotificationTask	0
125	17	com.sapienter.jbilling.server.order.task.OrderChangeApplyOrderStatusTask	0
101	17	com.sapienter.jbilling.server.user.tasks.EventBasedCustomNotificationTask	0
126	22	com.sapienter.jbilling.server.pluggableTask.InactiveUserManagementTask	0
32	15	com.sapienter.jbilling.server.mediation.task.SeparatorFileReader	2
33	16	com.sapienter.jbilling.server.mediation.task.TestMediationTask	0
34	15	com.sapienter.jbilling.server.mediation.task.FixedFileReader	2
44	15	com.sapienter.jbilling.server.mediation.task.JDBCReader	0
45	15	com.sapienter.jbilling.server.mediation.task.MySQLReader	0
71	21	com.sapienter.jbilling.server.mediation.task.SaveToFileMediationErrorHandler	0
73	21	com.sapienter.jbilling.server.mediation.task.SaveToJDBCMediationErrorHandler	1
81	22	com.sapienter.jbilling.server.mediation.task.MediationProcessTask	0
127	14	in.webdataconsulting.jbilling.server.pricing.tasks.BasicUsageBasedPricingTask	0
\.


--
-- Data for Name: pluggable_task_type_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pluggable_task_type_category (id, interface_name) FROM stdin;
1	com.sapienter.jbilling.server.pluggableTask.OrderProcessingTask
2	com.sapienter.jbilling.server.pluggableTask.OrderFilterTask
3	com.sapienter.jbilling.server.pluggableTask.InvoiceFilterTask
4	com.sapienter.jbilling.server.pluggableTask.InvoiceCompositionTask
5	com.sapienter.jbilling.server.pluggableTask.OrderPeriodTask
6	com.sapienter.jbilling.server.pluggableTask.PaymentTask
7	com.sapienter.jbilling.server.pluggableTask.NotificationTask
8	com.sapienter.jbilling.server.pluggableTask.PaymentInfoTask
9	com.sapienter.jbilling.server.pluggableTask.PenaltyTask
10	com.sapienter.jbilling.server.pluggableTask.ProcessorAlarm
11	com.sapienter.jbilling.server.user.tasks.ISubscriptionStatusManager
12	com.sapienter.jbilling.server.payment.tasks.IAsyncPaymentParameters
13	com.sapienter.jbilling.server.item.tasks.IItemPurchaseManager
14	com.sapienter.jbilling.server.pricing.tasks.IPricing
17	com.sapienter.jbilling.server.system.event.task.IInternalEventsTask
19	com.sapienter.jbilling.server.user.tasks.IValidatePurchaseTask
20	com.sapienter.jbilling.server.process.task.IBillingProcessFilterTask
22	com.sapienter.jbilling.server.process.task.IScheduledTask
23	com.sapienter.jbilling.server.rule.task.IRulesGenerator
24	com.sapienter.jbilling.server.process.task.IAgeingTask
25	com.sapienter.jbilling.server.user.partner.task.IPartnerCommissionTask
26	com.sapienter.jbilling.server.process.task.IFileExchangeTask
15	com.sapienter.jbilling.server.mediation.task.IMediationReader
16	com.sapienter.jbilling.server.mediation.task.IMediationProcess
21	com.sapienter.jbilling.server.mediation.task.IMediationErrorHandler
\.


--
-- Data for Name: preference; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.preference (id, type_id, table_id, foreign_id, value) FROM stdin;
10	14	5	10	1
11	18	5	10	
12	19	5	10	1
\.


--
-- Data for Name: preference_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.preference_type (id, def_value, validation_rule_id) FROM stdin;
4	\N	\N
13	\N	\N
14	\N	\N
15	\N	\N
16	\N	\N
17	\N	\N
18	\N	\N
19	1	\N
20	1	\N
21	0	\N
22	\N	\N
23	\N	\N
24	0	\N
25	0	\N
27	0	\N
28	\N	\N
29	https://www.paypal.com/en_US/i/btn/x-click-but6.gif	\N
30	\N	\N
32	0	\N
33	0	\N
35	0	\N
36	1	\N
38	1	\N
41	0	\N
43	0	\N
44	0	\N
45	0	\N
46	0	\N
49	\N	\N
50	2	\N
51	0	\N
52	0	\N
53	0	\N
31		\N
55	0	\N
63	0	\N
61	INVOICE	\N
64	realm	\N
65	0	\N
66	0	\N
67	1	\N
68	0	\N
71	24	\N
75	0	\N
39	0	1
40	0	2
76	10	4
\.


--
-- Data for Name: process_run; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.process_run (id, process_id, run_date, started, finished, payment_finished, invoices_generated, optlock, status_id) FROM stdin;
\.


--
-- Data for Name: process_run_total; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.process_run_total (id, process_run_id, currency_id, total_invoiced, total_paid, total_not_paid, optlock) FROM stdin;
\.


--
-- Data for Name: process_run_total_pm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.process_run_total_pm (id, process_run_total_id, payment_method_id, total, optlock) FROM stdin;
\.


--
-- Data for Name: process_run_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.process_run_user (id, process_run_id, user_id, status, created, optlock) FROM stdin;
\.


--
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion (id, item_id, code, notes, once, since, until) FROM stdin;
\.


--
-- Data for Name: promotion_user_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_user_map (user_id, promotion_id) FROM stdin;
\.


--
-- Data for Name: purchase_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_order (id, user_id, period_id, billing_type_id, active_since, active_until, cycle_start, create_datetime, next_billable_day, created_by, status_id, currency_id, deleted, notify, last_notified, notification_step, due_date_unit_id, due_date_value, df_fm, anticipate_periods, own_invoice, notes, notes_in_invoice, optlock, primary_order_id, prorate_flag, parent_order_id, cancellation_fee_type, cancellation_fee, cancellation_fee_percentage, cancellation_maximum_fee, cancellation_minimum_period, reseller_order, free_usage_quantity, deleted_date) FROM stdin;
\.


--
-- Data for Name: rating_unit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rating_unit (id, name, entity_id, price_unit_name, increment_unit_name, increment_unit_quantity, can_be_deleted, optlock) FROM stdin;
\.


--
-- Data for Name: recent_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recent_item (id, type, object_id, user_id, version) FROM stdin;
\.


--
-- Data for Name: report; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report (id, type_id, name, file_name, optlock) FROM stdin;
1	1	total_invoiced	total_invoiced.jasper	0
2	1	ageing_balance	ageing_balance.jasper	0
3	2	product_subscribers	product_subscribers.jasper	0
4	3	total_payments	total_payments.jasper	0
5	4	user_signups	user_signups.jasper	0
6	4	top_customers	top_customers.jasper	0
7	1	accounts_receivable	accounts_receivable.jasper	0
8	1	gl_detail	gl_detail.jasper	0
9	1	gl_summary	gl_summary.jasper	0
11	4	total_invoiced_per_customer	total_invoiced_per_customer.jasper	0
12	4	total_invoiced_per_customer_over_years	total_invoiced_per_customer_over_years.jasper	0
13	4	user_activity	user_activity.jasper	0
\.


--
-- Data for Name: report_parameter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_parameter (id, report_id, dtype, name) FROM stdin;
1	1	date	start_date
2	1	date	end_date
3	1	integer	period
4	3	integer	item_id
5	4	date	start_date
6	4	date	end_date
7	4	integer	period
8	5	date	start_date
9	5	date	end_date
10	5	integer	period
11	6	date	start_date
12	6	date	end_date
13	8	date	date
14	9	date	date
18	11	date	start_date
19	11	date	end_date
20	12	string	start_year
21	12	string	end_year
22	13	integer	activity_days
23	13	string	active_status
24	13	string	order_by
\.


--
-- Data for Name: report_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_type (id, name, optlock) FROM stdin;
1	invoice	0
2	order	0
3	payment	0
4	user	0
\.


--
-- Data for Name: reseller_entityid_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reseller_entityid_map (entity_id, user_id) FROM stdin;
\.


--
-- Data for Name: reserved_amounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reserved_amounts (id, session_id, ts_created, currency_id, reserved_amount, item_id, data, quantity) FROM stdin;
\.


--
-- Data for Name: reset_password_code; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reset_password_code (base_user_id, date_created, token, new_password) FROM stdin;
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role (id, entity_id, role_type_id) FROM stdin;
2	\N	2
3	\N	3
4	\N	4
5	\N	5
10	10	2
11	10	3
12	10	5
13	10	4
\.


--
-- Data for Name: route; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.route (id, name, table_name, entity_id, optlock, root_table, output_field_name, default_route, route_table) FROM stdin;
\.


--
-- Data for Name: shortcut; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shortcut (id, user_id, controller, action, name, object_id, version) FROM stdin;
\.


--
-- Data for Name: sure_tax_txn_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sure_tax_txn_log (id, txn_id, txn_type, txn_data, txn_date, resp_trans_id, request_type) FROM stdin;
\.


--
-- Data for Name: tab; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tab (id, message_code, controller_name, access_url, required_role, version, default_order) FROM stdin;
1	menu.link.customers	customer	/customer/list		1	1
2	menu.link.partners	partner	/partner/list		1	2
3	menu.link.invoices	invoice	/invoice/list		1	3
4	menu.link.payments.refunds	payment	/payment/list		1	4
5	menu.link.orders	order	/order/list		1	5
6	menu.link.billing	billing	/billing/list		1	6
8	menu.link.reports	report	/report/list		1	8
9	menu.link.products	product	/product/list		1	10
11	menu.link.configuration	config	/config/index		1	12
12	menu.link.discounts	discount	/discount/list		1	9
7	menu.link.mediation	mediation	/mediation/list		1	7
\.


--
-- Data for Name: tab_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tab_configuration (id, user_id, version) FROM stdin;
\.


--
-- Data for Name: tab_configuration_tab; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tab_configuration_tab (id, tab_id, tab_configuration_id, display_order, visible, version) FROM stdin;
\.


--
-- Data for Name: user_code; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_code (id, user_id, identifier, external_ref, type, type_desc, valid_from, valid_to) FROM stdin;
\.


--
-- Data for Name: user_code_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_code_link (id, user_code_id, object_type, object_id) FROM stdin;
\.


--
-- Data for Name: user_credit_card_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_credit_card_map (user_id, credit_card_id, id) FROM stdin;
\.


--
-- Name: user_credit_card_map_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_credit_card_map_id_seq', 1, false);


--
-- Data for Name: user_password_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_password_map (id, base_user_id, date_created, new_password) FROM stdin;
1	10	2016-11-13 21:52:33.838	$2a$10$gAP5kR6koQ/0R.MjLxawxerhXtW7rxi.k.MtqRoF8SOsQyFJUMPwS
100	10	2019-06-07 21:59:54.901	$2a$10$SRTAryLzbrZ/KKG2tq2jGeEneOXg8Yb.kCxaL8lw//uE78jQ09y3O
\.


--
-- Data for Name: user_role_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_role_map (user_id, role_id) FROM stdin;
10	10
\.


--
-- Data for Name: user_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_status (id, can_login) FROM stdin;
1	1
\.


--
-- Data for Name: validation_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.validation_rule (id, rule_type, enabled, optlock) FROM stdin;
1	RANGE	t	0
2	RANGE	t	0
3	RANGE	t	0
4	RANGE	t	0
10	PAYMENT_CARD	t	0
11	REGEX	t	0
12	REGEX	t	0
15	REGEX	t	0
14	PAYMENT_CARD	t	1
13	REGEX	t	1
16	SCRIPT	t	1
17	SCRIPT	t	0
18	SCRIPT	t	0
\.


--
-- Data for Name: validation_rule_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.validation_rule_attributes (validation_rule_id, attribute_name, attribute_value) FROM stdin;
1	minRange	0
1	maxRange	7
2	minRange	0
2	maxRange	91
3	minRange	0
3	maxRange	91
4	minRange	0
4	maxRange	600000
11	regularExpression	(?:0[1-9]|1[0-2])/[0-9]{4}
12	regularExpression	(?<=\\s|^)\\d+(?=\\s|$)
15	regularExpression	(?<=\\s|^)\\d+(?=\\s|$)
13	regularExpression	(?:0[1-9]|1[0-2])/[0-9]{4}
16	validationScript	_this ==~ /[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})/
17	validationScript	_this.value ==~ /[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})/
18	validationScript	_this.value ==~ /[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})/
\.


--
-- Name: account_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_type
    ADD CONSTRAINT account_type_pkey PRIMARY KEY (id);


--
-- Name: ach_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ach
    ADD CONSTRAINT ach_pkey PRIMARY KEY (id);


--
-- Name: ageing_entity_step_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ageing_entity_step
    ADD CONSTRAINT ageing_entity_step_pkey PRIMARY KEY (id);


--
-- Name: asset_assignment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_assignment
    ADD CONSTRAINT asset_assignment_pkey PRIMARY KEY (id);


--
-- Name: asset_entity_map_uc_1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_entity_map
    ADD CONSTRAINT asset_entity_map_uc_1 UNIQUE (asset_id, entity_id);


--
-- Name: asset_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset
    ADD CONSTRAINT asset_pkey PRIMARY KEY (id);


--
-- Name: asset_reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_reservation
    ADD CONSTRAINT asset_reservation_pkey PRIMARY KEY (id);


--
-- Name: asset_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_status
    ADD CONSTRAINT asset_status_pkey PRIMARY KEY (id);


--
-- Name: asset_transition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transition
    ADD CONSTRAINT asset_transition_pkey PRIMARY KEY (id);


--
-- Name: base_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_user
    ADD CONSTRAINT base_user_pkey PRIMARY KEY (id);


--
-- Name: batch_job_execution_context_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.batch_job_execution_context
    ADD CONSTRAINT batch_job_execution_context_pkey PRIMARY KEY (job_execution_id);


--
-- Name: batch_job_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.batch_job_execution
    ADD CONSTRAINT batch_job_execution_pkey PRIMARY KEY (job_execution_id);


--
-- Name: batch_job_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.batch_job_instance
    ADD CONSTRAINT batch_job_instance_pkey PRIMARY KEY (job_instance_id);


--
-- Name: batch_step_execution_context_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.batch_step_execution_context
    ADD CONSTRAINT batch_step_execution_context_pkey PRIMARY KEY (step_execution_id);


--
-- Name: batch_step_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.batch_step_execution
    ADD CONSTRAINT batch_step_execution_pkey PRIMARY KEY (step_execution_id);


--
-- Name: billing_process_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_process_configuration
    ADD CONSTRAINT billing_process_config_pkey PRIMARY KEY (id);


--
-- Name: billing_process_failed_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_process_failed_user
    ADD CONSTRAINT billing_process_failed_user_pkey PRIMARY KEY (id);


--
-- Name: billing_process_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.batch_process_info
    ADD CONSTRAINT billing_process_info_pkey PRIMARY KEY (id);


--
-- Name: billing_process_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_process
    ADD CONSTRAINT billing_process_pkey PRIMARY KEY (id);


--
-- Name: blacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blacklist
    ADD CONSTRAINT blacklist_pkey PRIMARY KEY (id);


--
-- Name: breadcrumb_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.breadcrumb
    ADD CONSTRAINT breadcrumb_pkey PRIMARY KEY (id);


--
-- Name: cdrentries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cdrentries
    ADD CONSTRAINT cdrentries_pkey PRIMARY KEY (id);


--
-- Name: charge_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.charge_sessions
    ADD CONSTRAINT charge_sessions_pkey PRIMARY KEY (id);


--
-- Name: contact_map_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_map
    ADD CONSTRAINT contact_map_pkey PRIMARY KEY (id);


--
-- Name: contact_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);


--
-- Name: country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: credit_card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_card
    ADD CONSTRAINT credit_card_pkey PRIMARY KEY (id);


--
-- Name: currency_entity_map_compositekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency_entity_map
    ADD CONSTRAINT currency_entity_map_compositekey PRIMARY KEY (currency_id, entity_id);


--
-- Name: currency_exchange_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency_exchange
    ADD CONSTRAINT currency_exchange_pkey PRIMARY KEY (id);


--
-- Name: currency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (id);


--
-- Name: customer_account_info_type_timeline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_account_info_type_timeline
    ADD CONSTRAINT customer_account_info_type_timeline_pkey PRIMARY KEY (id);


--
-- Name: customer_account_info_type_timeline_uk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_account_info_type_timeline
    ADD CONSTRAINT customer_account_info_type_timeline_uk UNIQUE (customer_id, meta_field_value_id, account_info_type_id);


--
-- Name: customer_meta_field_map_compositekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_meta_field_map
    ADD CONSTRAINT customer_meta_field_map_compositekey PRIMARY KEY (customer_id, meta_field_value_id);


--
-- Name: customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: discount_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount_attribute
    ADD CONSTRAINT discount_attribute_pkey PRIMARY KEY (discount_id, attribute_name);


--
-- Name: discount_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount_line
    ADD CONSTRAINT discount_line_pkey PRIMARY KEY (id);


--
-- Name: discount_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount
    ADD CONSTRAINT discount_pkey PRIMARY KEY (id);


--
-- Name: entity_delivery_method_map_compositekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_delivery_method_map
    ADD CONSTRAINT entity_delivery_method_map_compositekey PRIMARY KEY (method_id, entity_id);


--
-- Name: entity_payment_method_map_compositekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_payment_method_map
    ADD CONSTRAINT entity_payment_method_map_compositekey PRIMARY KEY (entity_id, payment_method_id);


--
-- Name: entity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity
    ADD CONSTRAINT entity_pkey PRIMARY KEY (id);


--
-- Name: entity_report_map_compositekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_report_map
    ADD CONSTRAINT entity_report_map_compositekey PRIMARY KEY (report_id, entity_id);


--
-- Name: entity_step_days; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ageing_entity_step
    ADD CONSTRAINT entity_step_days UNIQUE (entity_id, days);


--
-- Name: enumeration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enumeration
    ADD CONSTRAINT enumeration_pkey PRIMARY KEY (id);


--
-- Name: enumeration_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enumeration_values
    ADD CONSTRAINT enumeration_values_pkey PRIMARY KEY (id);


--
-- Name: event_log_message_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_log_message
    ADD CONSTRAINT event_log_message_pkey PRIMARY KEY (id);


--
-- Name: event_log_module_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_log_module
    ADD CONSTRAINT event_log_module_pkey PRIMARY KEY (id);


--
-- Name: event_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_log
    ADD CONSTRAINT event_log_pkey PRIMARY KEY (id);


--
-- Name: filter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.filter
    ADD CONSTRAINT filter_pkey PRIMARY KEY (id);


--
-- Name: filter_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.filter_set
    ADD CONSTRAINT filter_set_pkey PRIMARY KEY (id);


--
-- Name: generic_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generic_status
    ADD CONSTRAINT generic_status_pkey PRIMARY KEY (id);


--
-- Name: generic_status_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generic_status_type
    ADD CONSTRAINT generic_status_type_pkey PRIMARY KEY (id);


--
-- Name: international_description_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.international_description
    ADD CONSTRAINT international_description_pkey PRIMARY KEY (table_id, foreign_id, psudo_column, language_id);


--
-- Name: invoice_delivery_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_delivery_method
    ADD CONSTRAINT invoice_delivery_method_pkey PRIMARY KEY (id);


--
-- Name: invoice_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_line
    ADD CONSTRAINT invoice_line_pkey PRIMARY KEY (id);


--
-- Name: invoice_line_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_line_type
    ADD CONSTRAINT invoice_line_type_pkey PRIMARY KEY (id);


--
-- Name: invoice_meta_field_map_compositekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_meta_field_map
    ADD CONSTRAINT invoice_meta_field_map_compositekey PRIMARY KEY (invoice_id, meta_field_value_id);


--
-- Name: invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (id);


--
-- Name: item_dependency_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_dependency
    ADD CONSTRAINT item_dependency_pk PRIMARY KEY (id);


--
-- Name: item_entity_map_uc_1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_entity_map
    ADD CONSTRAINT item_entity_map_uc_1 UNIQUE (entity_id, item_id);


--
-- Name: item_meta_field_map_compositekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_meta_field_map
    ADD CONSTRAINT item_meta_field_map_compositekey PRIMARY KEY (item_id, meta_field_value_id);


--
-- Name: item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_pkey PRIMARY KEY (id);


--
-- Name: item_price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_price
    ADD CONSTRAINT item_price_pkey PRIMARY KEY (id);


--
-- Name: item_type_exclude_map_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_type_exclude_map
    ADD CONSTRAINT item_type_exclude_map_pkey PRIMARY KEY (item_id, type_id);


--
-- Name: item_type_map_compositekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_type_map
    ADD CONSTRAINT item_type_map_compositekey PRIMARY KEY (item_id, type_id);


--
-- Name: item_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_type
    ADD CONSTRAINT item_type_pkey PRIMARY KEY (id);


--
-- Name: jbilling_seqs_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jbilling_seqs
    ADD CONSTRAINT jbilling_seqs_pk PRIMARY KEY (name);


--
-- Name: jbilling_table_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jbilling_table
    ADD CONSTRAINT jbilling_table_pkey PRIMARY KEY (id);


--
-- Name: language_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language
    ADD CONSTRAINT language_pkey PRIMARY KEY (id);


--
-- Name: matching_field_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matching_field
    ADD CONSTRAINT matching_field_pkey PRIMARY KEY (id);


--
-- Name: mediation_cfg_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mediation_cfg
    ADD CONSTRAINT mediation_cfg_pkey PRIMARY KEY (id);


--
-- Name: mediation_errors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mediation_errors
    ADD CONSTRAINT mediation_errors_pkey PRIMARY KEY (accountcode);


--
-- Name: mediation_process_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mediation_process
    ADD CONSTRAINT mediation_process_pkey PRIMARY KEY (id);


--
-- Name: mediation_record_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mediation_record_line
    ADD CONSTRAINT mediation_record_line_pkey PRIMARY KEY (id);


--
-- Name: mediation_record_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mediation_record
    ADD CONSTRAINT mediation_record_pkey PRIMARY KEY (id);


--
-- Name: meta_field_name_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meta_field_name
    ADD CONSTRAINT meta_field_name_pkey PRIMARY KEY (id);


--
-- Name: meta_field_value_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meta_field_value
    ADD CONSTRAINT meta_field_value_id_key UNIQUE (id);


--
-- Name: metafield_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meta_field_group
    ADD CONSTRAINT metafield_group_pkey PRIMARY KEY (id);


--
-- Name: notification_category_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_category
    ADD CONSTRAINT notification_category_pk PRIMARY KEY (id);


--
-- Name: notifictn_msg_arch_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_message_arch_line
    ADD CONSTRAINT notifictn_msg_arch_line_pkey PRIMARY KEY (id);


--
-- Name: notifictn_msg_arch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_message_arch
    ADD CONSTRAINT notifictn_msg_arch_pkey PRIMARY KEY (id);


--
-- Name: notifictn_msg_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_message_line
    ADD CONSTRAINT notifictn_msg_line_pkey PRIMARY KEY (id);


--
-- Name: notifictn_msg_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_message
    ADD CONSTRAINT notifictn_msg_pkey PRIMARY KEY (id);


--
-- Name: notifictn_msg_section_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_message_section
    ADD CONSTRAINT notifictn_msg_section_pkey PRIMARY KEY (id);


--
-- Name: notifictn_msg_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_message_type
    ADD CONSTRAINT notifictn_msg_type_pkey PRIMARY KEY (id);


--
-- Name: order_billing_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_billing_type
    ADD CONSTRAINT order_billing_type_pkey PRIMARY KEY (id);


--
-- Name: order_change_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_pkey PRIMARY KEY (id);


--
-- Name: order_change_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_type
    ADD CONSTRAINT order_change_type_pkey PRIMARY KEY (id);


--
-- Name: order_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT order_line_pkey PRIMARY KEY (id);


--
-- Name: order_line_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_type
    ADD CONSTRAINT order_line_type_pkey PRIMARY KEY (id);


--
-- Name: order_meta_field_map_compositekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_meta_field_map
    ADD CONSTRAINT order_meta_field_map_compositekey PRIMARY KEY (order_id, meta_field_value_id);


--
-- Name: order_period_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_period
    ADD CONSTRAINT order_period_pkey PRIMARY KEY (id);


--
-- Name: order_process_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_process
    ADD CONSTRAINT order_process_pkey PRIMARY KEY (id);


--
-- Name: order_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status
    ADD CONSTRAINT order_status_pkey PRIMARY KEY (id);


--
-- Name: paper_invoice_batch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paper_invoice_batch
    ADD CONSTRAINT paper_invoice_batch_pkey PRIMARY KEY (id);


--
-- Name: partner_meta_field_map_compositekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.partner_meta_field_map
    ADD CONSTRAINT partner_meta_field_map_compositekey PRIMARY KEY (partner_id, meta_field_value_id);


--
-- Name: partner_payout_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.partner_payout
    ADD CONSTRAINT partner_payout_pkey PRIMARY KEY (id);


--
-- Name: partner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.partner
    ADD CONSTRAINT partner_pkey PRIMARY KEY (id);


--
-- Name: payment_authorization_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_authorization
    ADD CONSTRAINT payment_authorization_pkey PRIMARY KEY (id);


--
-- Name: payment_info_cheque_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_info_cheque
    ADD CONSTRAINT payment_info_cheque_pkey PRIMARY KEY (id);


--
-- Name: payment_information_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_information
    ADD CONSTRAINT payment_information_pkey PRIMARY KEY (id);


--
-- Name: payment_instrument_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_instrument_info
    ADD CONSTRAINT payment_instrument_info_pkey PRIMARY KEY (id);


--
-- Name: payment_invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_invoice
    ADD CONSTRAINT payment_invoice_pkey PRIMARY KEY (id);


--
-- Name: payment_meta_field_map_compositekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_meta_field_map
    ADD CONSTRAINT payment_meta_field_map_compositekey PRIMARY KEY (payment_id, meta_field_value_id);


--
-- Name: payment_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method
    ADD CONSTRAINT payment_method_pkey PRIMARY KEY (id);


--
-- Name: payment_method_template_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method_template
    ADD CONSTRAINT payment_method_template_pkey PRIMARY KEY (id);


--
-- Name: payment_method_template_template_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method_template
    ADD CONSTRAINT payment_method_template_template_name_key UNIQUE (template_name);


--
-- Name: payment_method_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method_type
    ADD CONSTRAINT payment_method_type_pkey PRIMARY KEY (id);


--
-- Name: payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- Name: payment_result_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_result
    ADD CONSTRAINT payment_result_pkey PRIMARY KEY (id);


--
-- Name: period_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.period_unit
    ADD CONSTRAINT period_unit_pkey PRIMARY KEY (id);


--
-- Name: pk_customer_notes; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_notes
    ADD CONSTRAINT pk_customer_notes PRIMARY KEY (id);


--
-- Name: pk_data_table_query; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_table_query
    ADD CONSTRAINT pk_data_table_query PRIMARY KEY (id);


--
-- Name: pk_data_table_query_entry; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_table_query_entry
    ADD CONSTRAINT pk_data_table_query_entry PRIMARY KEY (id);


--
-- Name: pk_databasechangeloglock; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id);


--
-- Name: pk_discount_meta_field_map; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount_meta_field_map
    ADD CONSTRAINT pk_discount_meta_field_map PRIMARY KEY (discount_id, meta_field_value_id);


--
-- Name: pk_notification_medium_type; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_medium_type
    ADD CONSTRAINT pk_notification_medium_type PRIMARY KEY (notification_id, medium_type);


--
-- Name: pk_rating_unit; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating_unit
    ADD CONSTRAINT pk_rating_unit PRIMARY KEY (id);


--
-- Name: pk_reset_password_code; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reset_password_code
    ADD CONSTRAINT pk_reset_password_code PRIMARY KEY (token);


--
-- Name: pluggable_task_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pluggable_task_parameter
    ADD CONSTRAINT pluggable_task_parameter_pkey PRIMARY KEY (id);


--
-- Name: pluggable_task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pluggable_task
    ADD CONSTRAINT pluggable_task_pkey PRIMARY KEY (id);


--
-- Name: pluggable_task_type_cat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pluggable_task_type_category
    ADD CONSTRAINT pluggable_task_type_cat_pkey PRIMARY KEY (id);


--
-- Name: pluggable_task_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pluggable_task_type
    ADD CONSTRAINT pluggable_task_type_pkey PRIMARY KEY (id);


--
-- Name: preference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preference
    ADD CONSTRAINT preference_pkey PRIMARY KEY (id);


--
-- Name: preference_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preference_type
    ADD CONSTRAINT preference_type_pkey PRIMARY KEY (id);


--
-- Name: process_run_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_run
    ADD CONSTRAINT process_run_pkey PRIMARY KEY (id);


--
-- Name: process_run_total_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_run_total
    ADD CONSTRAINT process_run_total_pkey PRIMARY KEY (id);


--
-- Name: process_run_total_pm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_run_total_pm
    ADD CONSTRAINT process_run_total_pm_pkey PRIMARY KEY (id);


--
-- Name: process_run_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_run_user
    ADD CONSTRAINT process_run_user_pkey PRIMARY KEY (id);


--
-- Name: promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (id);


--
-- Name: promotion_user_map_compositekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_user_map
    ADD CONSTRAINT promotion_user_map_compositekey PRIMARY KEY (user_id, promotion_id);


--
-- Name: purchase_order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order
    ADD CONSTRAINT purchase_order_pkey PRIMARY KEY (id);


--
-- Name: recent_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recent_item
    ADD CONSTRAINT recent_item_pkey PRIMARY KEY (id);


--
-- Name: report_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_parameter
    ADD CONSTRAINT report_parameter_pkey PRIMARY KEY (id);


--
-- Name: report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report
    ADD CONSTRAINT report_pkey PRIMARY KEY (id);


--
-- Name: report_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_type
    ADD CONSTRAINT report_type_pkey PRIMARY KEY (id);


--
-- Name: reserved_amounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reserved_amounts
    ADD CONSTRAINT reserved_amounts_pkey PRIMARY KEY (id);


--
-- Name: reset_password_code_base_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reset_password_code
    ADD CONSTRAINT reset_password_code_base_user_id_key UNIQUE (base_user_id);


--
-- Name: role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: route_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.route
    ADD CONSTRAINT route_pkey PRIMARY KEY (id);


--
-- Name: shortcut_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shortcut
    ADD CONSTRAINT shortcut_pkey PRIMARY KEY (id);


--
-- Name: sure_tax_txn_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sure_tax_txn_log
    ADD CONSTRAINT sure_tax_txn_log_pkey PRIMARY KEY (id);


--
-- Name: tab_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tab_configuration
    ADD CONSTRAINT tab_configuration_pkey PRIMARY KEY (id);


--
-- Name: tab_configuration_tab_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tab_configuration_tab
    ADD CONSTRAINT tab_configuration_tab_pkey PRIMARY KEY (id);


--
-- Name: tab_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tab
    ADD CONSTRAINT tab_pkey PRIMARY KEY (id);


--
-- Name: user_code_link_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_code_link
    ADD CONSTRAINT user_code_link_pkey PRIMARY KEY (id);


--
-- Name: user_code_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_code
    ADD CONSTRAINT user_code_pkey PRIMARY KEY (id);


--
-- Name: user_password_map_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_password_map
    ADD CONSTRAINT user_password_map_pkey PRIMARY KEY (id);


--
-- Name: user_role_map_compositekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role_map
    ADD CONSTRAINT user_role_map_compositekey PRIMARY KEY (user_id, role_id);


--
-- Name: user_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_status
    ADD CONSTRAINT user_status_pkey PRIMARY KEY (id);


--
-- Name: validation_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.validation_rule
    ADD CONSTRAINT validation_rule_pkey PRIMARY KEY (id);


--
-- Name: asset_reservation_end_date_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asset_reservation_end_date_index ON public.asset_reservation USING btree (end_date);


--
-- Name: bp_pm_index_total; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bp_pm_index_total ON public.process_run_total_pm USING btree (process_run_total_id);


--
-- Name: contact_i_del; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX contact_i_del ON public.contact USING btree (deleted);


--
-- Name: contact_map_i_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX contact_map_i_2 ON public.contact_map USING btree (table_id, foreign_id);


--
-- Name: create_datetime; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX create_datetime ON public.payment_authorization USING btree (create_datetime);


--
-- Name: currency_entity_map_i_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX currency_entity_map_i_2 ON public.currency_entity_map USING btree (currency_id, entity_id);


--
-- Name: international_description_i_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX international_description_i_2 ON public.international_description USING btree (table_id, foreign_id, language_id);


--
-- Name: ix_base_user_un; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_base_user_un ON public.base_user USING btree (entity_id, user_name);


--
-- Name: ix_blacklist_entity_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_blacklist_entity_type ON public.blacklist USING btree (entity_id, type);


--
-- Name: ix_blacklist_user_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_blacklist_user_type ON public.blacklist USING btree (user_id, type);


--
-- Name: ix_cc_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_cc_number ON public.credit_card USING btree (cc_number_plain);


--
-- Name: ix_cc_number_encrypted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_cc_number_encrypted ON public.credit_card USING btree (cc_number);


--
-- Name: ix_contact_address; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_contact_address ON public.contact USING btree (street_addres1, city, postal_code, street_addres2, state_province, country_code);


--
-- Name: ix_contact_fname; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_contact_fname ON public.contact USING btree (first_name);


--
-- Name: ix_contact_fname_lname; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_contact_fname_lname ON public.contact USING btree (first_name, last_name);


--
-- Name: ix_contact_lname; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_contact_lname ON public.contact USING btree (last_name);


--
-- Name: ix_contact_orgname; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_contact_orgname ON public.contact USING btree (organization_name);


--
-- Name: ix_contact_phone; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_contact_phone ON public.contact USING btree (phone_phone_number, phone_area_code, phone_country_code);


--
-- Name: ix_el_main; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_el_main ON public.event_log USING btree (module_id, message_id, create_datetime);


--
-- Name: ix_invoice_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_invoice_date ON public.invoice USING btree (create_datetime);


--
-- Name: ix_invoice_due_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_invoice_due_date ON public.invoice USING btree (user_id, due_date);


--
-- Name: ix_invoice_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_invoice_number ON public.invoice USING btree (user_id, public_number);


--
-- Name: ix_invoice_ts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_invoice_ts ON public.invoice USING btree (create_timestamp, user_id);


--
-- Name: ix_invoice_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_invoice_user_id ON public.invoice USING btree (user_id, deleted);


--
-- Name: ix_item_ent; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_item_ent ON public.item USING btree (entity_id, internal_number);


--
-- Name: ix_order_process_in; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_order_process_in ON public.order_process USING btree (invoice_id);


--
-- Name: ix_parent_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_parent_customer_id ON public.customer USING btree (parent_id);


--
-- Name: ix_promotion_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_promotion_code ON public.promotion USING btree (code);


--
-- Name: ix_purchase_order_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_purchase_order_date ON public.purchase_order USING btree (user_id, create_datetime);


--
-- Name: ix_uq_order_process_or_bp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_uq_order_process_or_bp ON public.order_process USING btree (order_id, billing_process_id);


--
-- Name: ix_uq_order_process_or_in; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_uq_order_process_or_in ON public.order_process USING btree (order_id, invoice_id);


--
-- Name: ix_uq_payment_inv_map_pa_in; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_uq_payment_inv_map_pa_in ON public.payment_invoice USING btree (payment_id, invoice_id);


--
-- Name: mediation_record_i; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mediation_record_i ON public.mediation_record USING btree (id_key, status_id);


--
-- Name: order_change_idx_order_line; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX order_change_idx_order_line ON public.order_change USING btree (order_line_id);


--
-- Name: payment_i_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_i_2 ON public.payment USING btree (user_id, create_datetime);


--
-- Name: payment_i_3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_i_3 ON public.payment USING btree (user_id, balance);


--
-- Name: promotion_user_map_i_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX promotion_user_map_i_2 ON public.promotion_user_map USING btree (user_id, promotion_id);


--
-- Name: purchase_order_i_notif; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX purchase_order_i_notif ON public.purchase_order USING btree (active_until, notification_step);


--
-- Name: purchase_order_i_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX purchase_order_i_user ON public.purchase_order USING btree (user_id, deleted);


--
-- Name: transaction_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX transaction_id ON public.payment_authorization USING btree (transaction_id);


--
-- Name: user_credit_card_map_i_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_credit_card_map_i_2 ON public.user_credit_card_map USING btree (user_id, credit_card_id);


--
-- Name: user_role_map_i_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_role_map_i_2 ON public.user_role_map USING btree (user_id, role_id);


--
-- Name: account_type_currency_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_type
    ADD CONSTRAINT "account_type_currency_id_FK" FOREIGN KEY (currency_id) REFERENCES public.currency(id);


--
-- Name: account_type_entity_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_type
    ADD CONSTRAINT "account_type_entity_id_FK" FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: account_type_language_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_type
    ADD CONSTRAINT "account_type_language_id_FK" FOREIGN KEY (language_id) REFERENCES public.language(id);


--
-- Name: account_type_main_subscription_period_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_type
    ADD CONSTRAINT "account_type_main_subscription_period_FK" FOREIGN KEY (main_subscript_order_period_id) REFERENCES public.order_period(id);


--
-- Name: ach_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ach
    ADD CONSTRAINT ach_fk_1 FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: ageing_entity_step_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ageing_entity_step
    ADD CONSTRAINT ageing_entity_step_fk_2 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: asset_assignment_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_assignment
    ADD CONSTRAINT asset_assignment_fk_1 FOREIGN KEY (asset_id) REFERENCES public.asset(id);


--
-- Name: asset_assignment_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_assignment
    ADD CONSTRAINT asset_assignment_fk_2 FOREIGN KEY (order_line_id) REFERENCES public.order_line(id);


--
-- Name: asset_entity_map_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_entity_map
    ADD CONSTRAINT asset_entity_map_fk1 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: asset_entity_map_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_entity_map
    ADD CONSTRAINT asset_entity_map_fk2 FOREIGN KEY (asset_id) REFERENCES public.asset(id);


--
-- Name: asset_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset
    ADD CONSTRAINT asset_fk_1 FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: asset_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset
    ADD CONSTRAINT asset_fk_2 FOREIGN KEY (order_line_id) REFERENCES public.order_line(id);


--
-- Name: asset_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset
    ADD CONSTRAINT asset_fk_3 FOREIGN KEY (status_id) REFERENCES public.asset_status(id);


--
-- Name: asset_fk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset
    ADD CONSTRAINT asset_fk_4 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: asset_meta_field_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_meta_field_map
    ADD CONSTRAINT asset_meta_field_map_fk_1 FOREIGN KEY (asset_id) REFERENCES public.asset(id);


--
-- Name: asset_meta_field_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_meta_field_map
    ADD CONSTRAINT asset_meta_field_map_fk_2 FOREIGN KEY (meta_field_value_id) REFERENCES public.meta_field_value(id);


--
-- Name: asset_reservation_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_reservation
    ADD CONSTRAINT asset_reservation_fk_1 FOREIGN KEY (creator_user_id) REFERENCES public.base_user(id);


--
-- Name: asset_reservation_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_reservation
    ADD CONSTRAINT asset_reservation_fk_2 FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: asset_reservation_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_reservation
    ADD CONSTRAINT asset_reservation_fk_3 FOREIGN KEY (asset_id) REFERENCES public.asset(id);


--
-- Name: asset_status_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_status
    ADD CONSTRAINT asset_status_fk_1 FOREIGN KEY (item_type_id) REFERENCES public.item_type(id);


--
-- Name: asset_transition_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transition
    ADD CONSTRAINT asset_transition_fk_1 FOREIGN KEY (assigned_to_id) REFERENCES public.base_user(id);


--
-- Name: asset_transition_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transition
    ADD CONSTRAINT asset_transition_fk_2 FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: asset_transition_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transition
    ADD CONSTRAINT asset_transition_fk_3 FOREIGN KEY (asset_id) REFERENCES public.asset(id);


--
-- Name: asset_transition_fk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transition
    ADD CONSTRAINT asset_transition_fk_4 FOREIGN KEY (new_status_id) REFERENCES public.asset_status(id);


--
-- Name: asset_transition_fk_5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transition
    ADD CONSTRAINT asset_transition_fk_5 FOREIGN KEY (previous_status_id) REFERENCES public.asset_status(id);


--
-- Name: base_user_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_user
    ADD CONSTRAINT base_user_fk_3 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: base_user_fk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_user
    ADD CONSTRAINT base_user_fk_4 FOREIGN KEY (language_id) REFERENCES public.language(id);


--
-- Name: base_user_fk_5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_user
    ADD CONSTRAINT base_user_fk_5 FOREIGN KEY (currency_id) REFERENCES public.currency(id);


--
-- Name: base_user_fk_6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_user
    ADD CONSTRAINT base_user_fk_6 FOREIGN KEY (status_id) REFERENCES public.user_status(id);


--
-- Name: billing_proc_configtn_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_process_configuration
    ADD CONSTRAINT billing_proc_configtn_fk_1 FOREIGN KEY (period_unit_id) REFERENCES public.period_unit(id);


--
-- Name: billing_proc_configtn_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_process_configuration
    ADD CONSTRAINT billing_proc_configtn_fk_2 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: billing_process_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_process
    ADD CONSTRAINT billing_process_fk_1 FOREIGN KEY (period_unit_id) REFERENCES public.period_unit(id);


--
-- Name: billing_process_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_process
    ADD CONSTRAINT billing_process_fk_2 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: billing_process_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_process
    ADD CONSTRAINT billing_process_fk_3 FOREIGN KEY (paper_invoice_batch_id) REFERENCES public.paper_invoice_batch(id);


--
-- Name: blacklist_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blacklist
    ADD CONSTRAINT blacklist_fk_1 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: blacklist_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blacklist
    ADD CONSTRAINT blacklist_fk_2 FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: blacklist_fk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blacklist
    ADD CONSTRAINT blacklist_fk_4 FOREIGN KEY (meta_field_value_id) REFERENCES public.meta_field_value(id);


--
-- Name: category_id_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_message_type
    ADD CONSTRAINT category_id_fk_1 FOREIGN KEY (category_id) REFERENCES public.notification_category(id);


--
-- Name: contact_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_map
    ADD CONSTRAINT contact_map_fk_1 FOREIGN KEY (table_id) REFERENCES public.jbilling_table(id);


--
-- Name: contact_map_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_map
    ADD CONSTRAINT contact_map_fk_3 FOREIGN KEY (contact_id) REFERENCES public.contact(id);


--
-- Name: currency_entity_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency_entity_map
    ADD CONSTRAINT currency_entity_map_fk_1 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: currency_entity_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency_entity_map
    ADD CONSTRAINT currency_entity_map_fk_2 FOREIGN KEY (currency_id) REFERENCES public.currency(id);


--
-- Name: currency_exchange_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency_exchange
    ADD CONSTRAINT currency_exchange_fk_1 FOREIGN KEY (currency_id) REFERENCES public.currency(id);


--
-- Name: customer_account_info_type_timeline_account_info_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_account_info_type_timeline
    ADD CONSTRAINT customer_account_info_type_timeline_account_info_type_id_fk FOREIGN KEY (account_info_type_id) REFERENCES public.meta_field_group(id);


--
-- Name: customer_account_info_type_timeline_customer_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_account_info_type_timeline
    ADD CONSTRAINT customer_account_info_type_timeline_customer_id_fk FOREIGN KEY (customer_id) REFERENCES public.customer(id);


--
-- Name: customer_account_info_type_timeline_meta_field_value_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_account_info_type_timeline
    ADD CONSTRAINT customer_account_info_type_timeline_meta_field_value_id_fk FOREIGN KEY (meta_field_value_id) REFERENCES public.meta_field_value(id);


--
-- Name: customer_account_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_account_type_fk FOREIGN KEY (account_type_id) REFERENCES public.account_type(id);


--
-- Name: customer_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_fk_1 FOREIGN KEY (invoice_delivery_method_id) REFERENCES public.invoice_delivery_method(id);


--
-- Name: customer_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_fk_2 FOREIGN KEY (partner_id) REFERENCES public.partner(id);


--
-- Name: customer_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_fk_3 FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: customer_main_subscription_period_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT "customer_main_subscription_period_FK" FOREIGN KEY (main_subscript_order_period_id) REFERENCES public.order_period(id);


--
-- Name: customer_meta_field_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_meta_field_map
    ADD CONSTRAINT customer_meta_field_map_fk_1 FOREIGN KEY (customer_id) REFERENCES public.customer(id);


--
-- Name: customer_meta_field_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_meta_field_map
    ADD CONSTRAINT customer_meta_field_map_fk_2 FOREIGN KEY (meta_field_value_id) REFERENCES public.meta_field_value(id);


--
-- Name: customer_notes_customer_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_notes
    ADD CONSTRAINT "customer_notes_customer_id_FK" FOREIGN KEY (customer_id) REFERENCES public.customer(id);


--
-- Name: customer_notes_entity_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_notes
    ADD CONSTRAINT "customer_notes_entity_id_FK" FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: customer_notes_user_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_notes
    ADD CONSTRAINT "customer_notes_user_id_FK" FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: data_table_query_entry_next_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_table_query_entry
    ADD CONSTRAINT "data_table_query_entry_next_FK" FOREIGN KEY (next_entry_id) REFERENCES public.data_table_query_entry(id);


--
-- Name: data_table_query_next_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_table_query
    ADD CONSTRAINT "data_table_query_next_FK" FOREIGN KEY (root_entry_id) REFERENCES public.data_table_query_entry(id);


--
-- Name: discount_attr_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount_attribute
    ADD CONSTRAINT discount_attr_id_fk FOREIGN KEY (discount_id) REFERENCES public.discount(id);


--
-- Name: discount_entity_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount
    ADD CONSTRAINT discount_entity_id_fk FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: discount_line_discount_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount_line
    ADD CONSTRAINT discount_line_discount_id_fk FOREIGN KEY (discount_id) REFERENCES public.discount(id);


--
-- Name: discount_line_item_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount_line
    ADD CONSTRAINT discount_line_item_id_fk FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: discount_line_order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount_line
    ADD CONSTRAINT discount_line_order_id_fk FOREIGN KEY (order_id) REFERENCES public.purchase_order(id);


--
-- Name: discount_line_order_line_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount_line
    ADD CONSTRAINT discount_line_order_line_id_fk FOREIGN KEY (discount_order_line_id) REFERENCES public.order_line(id);


--
-- Name: discount_meta_field_map_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount_meta_field_map
    ADD CONSTRAINT discount_meta_field_map_fk1 FOREIGN KEY (discount_id) REFERENCES public.discount(id);


--
-- Name: discount_meta_field_map_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount_meta_field_map
    ADD CONSTRAINT discount_meta_field_map_fk2 FOREIGN KEY (meta_field_value_id) REFERENCES public.meta_field_value(id);


--
-- Name: entity_delivry_methd_map_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_delivery_method_map
    ADD CONSTRAINT entity_delivry_methd_map_fk1 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: entity_delivry_methd_map_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_delivery_method_map
    ADD CONSTRAINT entity_delivry_methd_map_fk2 FOREIGN KEY (method_id) REFERENCES public.invoice_delivery_method(id);


--
-- Name: entity_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity
    ADD CONSTRAINT entity_fk_1 FOREIGN KEY (currency_id) REFERENCES public.currency(id);


--
-- Name: entity_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity
    ADD CONSTRAINT entity_fk_2 FOREIGN KEY (language_id) REFERENCES public.language(id);


--
-- Name: entity_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity
    ADD CONSTRAINT entity_fk_3 FOREIGN KEY (parent_id) REFERENCES public.entity(id);


--
-- Name: entity_payment_method_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_payment_method_map
    ADD CONSTRAINT entity_payment_method_map_fk_1 FOREIGN KEY (payment_method_id) REFERENCES public.payment_method(id);


--
-- Name: entity_payment_method_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_payment_method_map
    ADD CONSTRAINT entity_payment_method_map_fk_2 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: enumeration_values_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enumeration_values
    ADD CONSTRAINT enumeration_values_fk_1 FOREIGN KEY (enumeration_id) REFERENCES public.enumeration(id);


--
-- Name: event_log_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_log
    ADD CONSTRAINT event_log_fk_1 FOREIGN KEY (module_id) REFERENCES public.event_log_module(id);


--
-- Name: event_log_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_log
    ADD CONSTRAINT event_log_fk_2 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: event_log_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_log
    ADD CONSTRAINT event_log_fk_3 FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: event_log_fk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_log
    ADD CONSTRAINT event_log_fk_4 FOREIGN KEY (table_id) REFERENCES public.jbilling_table(id);


--
-- Name: event_log_fk_5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_log
    ADD CONSTRAINT event_log_fk_5 FOREIGN KEY (message_id) REFERENCES public.event_log_message(id);


--
-- Name: event_log_fk_6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_log
    ADD CONSTRAINT event_log_fk_6 FOREIGN KEY (affected_user_id) REFERENCES public.base_user(id);


--
-- Name: fk_reservations_session; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reserved_amounts
    ADD CONSTRAINT fk_reservations_session FOREIGN KEY (session_id) REFERENCES public.charge_sessions(id);


--
-- Name: fk_sessions_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.charge_sessions
    ADD CONSTRAINT fk_sessions_user FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: generic_status_entity_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generic_status
    ADD CONSTRAINT generic_status_entity_id_fk FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: generic_status_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generic_status
    ADD CONSTRAINT generic_status_fk_1 FOREIGN KEY (dtype) REFERENCES public.generic_status_type(id);


--
-- Name: international_description_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.international_description
    ADD CONSTRAINT international_description_fk_1 FOREIGN KEY (language_id) REFERENCES public.language(id);


--
-- Name: invoice_delivery_method_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_type
    ADD CONSTRAINT "invoice_delivery_method_id_FK" FOREIGN KEY (invoice_delivery_method_id) REFERENCES public.invoice_delivery_method(id);


--
-- Name: invoice_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_fk_1 FOREIGN KEY (billing_process_id) REFERENCES public.billing_process(id);


--
-- Name: invoice_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_fk_2 FOREIGN KEY (paper_invoice_batch_id) REFERENCES public.paper_invoice_batch(id);


--
-- Name: invoice_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_fk_3 FOREIGN KEY (currency_id) REFERENCES public.currency(id);


--
-- Name: invoice_fk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_fk_4 FOREIGN KEY (delegated_invoice_id) REFERENCES public.invoice(id);


--
-- Name: invoice_line_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_line
    ADD CONSTRAINT invoice_line_fk_1 FOREIGN KEY (invoice_id) REFERENCES public.invoice(id);


--
-- Name: invoice_line_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_line
    ADD CONSTRAINT invoice_line_fk_2 FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: invoice_line_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_line
    ADD CONSTRAINT invoice_line_fk_3 FOREIGN KEY (type_id) REFERENCES public.invoice_line_type(id);


--
-- Name: invoice_line_fk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_line
    ADD CONSTRAINT invoice_line_fk_4 FOREIGN KEY (order_id) REFERENCES public.purchase_order(id);


--
-- Name: invoice_meta_field_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_meta_field_map
    ADD CONSTRAINT invoice_meta_field_map_fk_1 FOREIGN KEY (invoice_id) REFERENCES public.invoice(id);


--
-- Name: invoice_meta_field_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_meta_field_map
    ADD CONSTRAINT invoice_meta_field_map_fk_2 FOREIGN KEY (meta_field_value_id) REFERENCES public.meta_field_value(id);


--
-- Name: item_dependency_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_dependency
    ADD CONSTRAINT item_dependency_fk1 FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: item_dependency_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_dependency
    ADD CONSTRAINT item_dependency_fk2 FOREIGN KEY (dependent_item_id) REFERENCES public.item(id);


--
-- Name: item_dependency_fk3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_dependency
    ADD CONSTRAINT item_dependency_fk3 FOREIGN KEY (dependent_item_type_id) REFERENCES public.item_type(id);


--
-- Name: item_entity_map_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_entity_map
    ADD CONSTRAINT item_entity_map_fk1 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: item_entity_map_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_entity_map
    ADD CONSTRAINT item_entity_map_fk2 FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: item_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_fk_1 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: item_meta_field_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_meta_field_map
    ADD CONSTRAINT item_meta_field_map_fk_1 FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: item_meta_field_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_meta_field_map
    ADD CONSTRAINT item_meta_field_map_fk_2 FOREIGN KEY (meta_field_value_id) REFERENCES public.meta_field_value(id);


--
-- Name: item_price_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_price
    ADD CONSTRAINT item_price_fk_1 FOREIGN KEY (currency_id) REFERENCES public.currency(id);


--
-- Name: item_price_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_price
    ADD CONSTRAINT item_price_fk_2 FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: item_type_entity_map_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_type_entity_map
    ADD CONSTRAINT item_type_entity_map_fk1 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: item_type_entity_map_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_type_entity_map
    ADD CONSTRAINT item_type_entity_map_fk2 FOREIGN KEY (item_type_id) REFERENCES public.item_type(id);


--
-- Name: item_type_exclude_item_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_type_exclude_map
    ADD CONSTRAINT item_type_exclude_item_id_fk FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: item_type_exclude_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_type_exclude_map
    ADD CONSTRAINT item_type_exclude_type_id_fk FOREIGN KEY (type_id) REFERENCES public.item_type(id);


--
-- Name: item_type_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_type
    ADD CONSTRAINT item_type_fk_1 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: item_type_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_type_map
    ADD CONSTRAINT item_type_map_fk_1 FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: item_type_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_type_map
    ADD CONSTRAINT item_type_map_fk_2 FOREIGN KEY (type_id) REFERENCES public.item_type(id);


--
-- Name: item_type_meta_field_def_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_type_meta_field_def_map
    ADD CONSTRAINT item_type_meta_field_def_map_fk_1 FOREIGN KEY (item_type_id) REFERENCES public.item_type(id);


--
-- Name: item_type_meta_field_def_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_type_meta_field_def_map
    ADD CONSTRAINT item_type_meta_field_def_map_fk_2 FOREIGN KEY (meta_field_id) REFERENCES public.meta_field_name(id);


--
-- Name: item_type_meta_field_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_type_meta_field_map
    ADD CONSTRAINT item_type_meta_field_type_fk FOREIGN KEY (item_type_id) REFERENCES public.item_type(id);


--
-- Name: item_type_meta_field_value_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_type_meta_field_map
    ADD CONSTRAINT item_type_meta_field_value_fk FOREIGN KEY (meta_field_value_id) REFERENCES public.meta_field_value(id);


--
-- Name: matching_field_route_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matching_field
    ADD CONSTRAINT "matching_field_route_id_FK" FOREIGN KEY (route_id) REFERENCES public.route(id);


--
-- Name: mediation_cfg_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mediation_cfg
    ADD CONSTRAINT mediation_cfg_fk_1 FOREIGN KEY (pluggable_task_id) REFERENCES public.pluggable_task(id);


--
-- Name: mediation_order_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mediation_order_map
    ADD CONSTRAINT mediation_order_map_fk_1 FOREIGN KEY (mediation_process_id) REFERENCES public.mediation_process(id);


--
-- Name: mediation_order_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mediation_order_map
    ADD CONSTRAINT mediation_order_map_fk_2 FOREIGN KEY (order_id) REFERENCES public.purchase_order(id);


--
-- Name: mediation_process_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mediation_process
    ADD CONSTRAINT mediation_process_fk_1 FOREIGN KEY (configuration_id) REFERENCES public.mediation_cfg(id);


--
-- Name: mediation_record_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mediation_record
    ADD CONSTRAINT mediation_record_fk_1 FOREIGN KEY (mediation_process_id) REFERENCES public.mediation_process(id);


--
-- Name: mediation_record_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mediation_record
    ADD CONSTRAINT mediation_record_fk_2 FOREIGN KEY (status_id) REFERENCES public.generic_status(id);


--
-- Name: mediation_record_line_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mediation_record_line
    ADD CONSTRAINT mediation_record_line_fk_1 FOREIGN KEY (mediation_record_id) REFERENCES public.mediation_record(id);


--
-- Name: mediation_record_line_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mediation_record_line
    ADD CONSTRAINT mediation_record_line_fk_2 FOREIGN KEY (order_line_id) REFERENCES public.order_line(id);


--
-- Name: meta_field_entity_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meta_field_name
    ADD CONSTRAINT meta_field_entity_id_fk FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: meta_field_group_account_type_FK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meta_field_group
    ADD CONSTRAINT "meta_field_group_account_type_FK2" FOREIGN KEY (account_type_id) REFERENCES public.account_type(id);


--
-- Name: meta_field_group_entity_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meta_field_group
    ADD CONSTRAINT "meta_field_group_entity_FK1" FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: meta_field_name_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meta_field_name
    ADD CONSTRAINT meta_field_name_fk_1 FOREIGN KEY (default_value_id) REFERENCES public.meta_field_value(id);


--
-- Name: meta_field_value_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meta_field_value
    ADD CONSTRAINT meta_field_value_fk_1 FOREIGN KEY (meta_field_name_id) REFERENCES public.meta_field_name(id);


--
-- Name: notif_mess_arch_line_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_message_arch_line
    ADD CONSTRAINT notif_mess_arch_line_fk_1 FOREIGN KEY (message_archive_id) REFERENCES public.notification_message_arch(id);


--
-- Name: notification_message_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_message
    ADD CONSTRAINT notification_message_fk_1 FOREIGN KEY (language_id) REFERENCES public.language(id);


--
-- Name: notification_message_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_message
    ADD CONSTRAINT notification_message_fk_2 FOREIGN KEY (type_id) REFERENCES public.notification_message_type(id);


--
-- Name: notification_message_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_message
    ADD CONSTRAINT notification_message_fk_3 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: notification_message_line_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_message_line
    ADD CONSTRAINT notification_message_line_fk_1 FOREIGN KEY (message_section_id) REFERENCES public.notification_message_section(id);


--
-- Name: notification_msg_section_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_message_section
    ADD CONSTRAINT notification_msg_section_fk_1 FOREIGN KEY (message_id) REFERENCES public.notification_message(id);


--
-- Name: ol_meta_field_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_meta_field_map
    ADD CONSTRAINT ol_meta_field_map_fk_1 FOREIGN KEY (order_line_id) REFERENCES public.order_line(id);


--
-- Name: ol_meta_field_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_meta_field_map
    ADD CONSTRAINT ol_meta_field_map_fk_2 FOREIGN KEY (meta_field_value_id) REFERENCES public.meta_field_value(id);


--
-- Name: ol_meta_fields_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_meta_fields_map
    ADD CONSTRAINT ol_meta_fields_map_fk_1 FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: ol_meta_fields_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_meta_fields_map
    ADD CONSTRAINT ol_meta_fields_map_fk_2 FOREIGN KEY (meta_field_id) REFERENCES public.meta_field_name(id);


--
-- Name: order_change_asset_map_asset_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_asset_map
    ADD CONSTRAINT order_change_asset_map_asset_id_fk FOREIGN KEY (asset_id) REFERENCES public.asset(id);


--
-- Name: order_change_asset_map_change_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_asset_map
    ADD CONSTRAINT order_change_asset_map_change_id_fk FOREIGN KEY (order_change_id) REFERENCES public.order_change(id);


--
-- Name: order_change_item_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_item_id_fk FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: order_change_meta_field_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_meta_field_map
    ADD CONSTRAINT order_change_meta_field_map_fk_1 FOREIGN KEY (order_change_id) REFERENCES public.order_change(id);


--
-- Name: order_change_meta_field_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_meta_field_map
    ADD CONSTRAINT order_change_meta_field_map_fk_2 FOREIGN KEY (meta_field_value_id) REFERENCES public.meta_field_value(id);


--
-- Name: order_change_order_change_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_order_change_type_id_fk FOREIGN KEY (order_change_type_id) REFERENCES public.order_change_type(id);


--
-- Name: order_change_order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_order_id_fk FOREIGN KEY (order_id) REFERENCES public.purchase_order(id);


--
-- Name: order_change_order_line_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_order_line_id_fk FOREIGN KEY (order_line_id) REFERENCES public.order_line(id);


--
-- Name: order_change_order_status_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_order_status_id_fk FOREIGN KEY (order_status_id) REFERENCES public.order_status(id);


--
-- Name: order_change_parent_order_change_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_parent_order_change_fk FOREIGN KEY (parent_order_change_id) REFERENCES public.order_change(id);


--
-- Name: order_change_parent_order_line_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_parent_order_line_id_fk FOREIGN KEY (parent_order_line_id) REFERENCES public.order_line(id);


--
-- Name: order_change_status_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_status_id_fk FOREIGN KEY (status_id) REFERENCES public.generic_status(id);


--
-- Name: order_change_type_entity_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_type
    ADD CONSTRAINT order_change_type_entity_id_fk FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: order_change_type_item_type_map_change_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_type_item_type_map
    ADD CONSTRAINT order_change_type_item_type_map_change_type_id_fk FOREIGN KEY (order_change_type_id) REFERENCES public.order_change_type(id);


--
-- Name: order_change_type_item_type_map_item_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_type_item_type_map
    ADD CONSTRAINT order_change_type_item_type_map_item_type_id_fk FOREIGN KEY (item_type_id) REFERENCES public.item_type(id);


--
-- Name: order_change_type_meta_field_map_change_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_type_meta_field_map
    ADD CONSTRAINT order_change_type_meta_field_map_change_type_id_fk FOREIGN KEY (order_change_type_id) REFERENCES public.order_change_type(id);


--
-- Name: order_change_type_meta_field_map_meta_field_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_type_meta_field_map
    ADD CONSTRAINT order_change_type_meta_field_map_meta_field_id_fk FOREIGN KEY (meta_field_id) REFERENCES public.meta_field_name(id);


--
-- Name: order_change_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_user_id_fk FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: order_change_user_status_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_user_status_id_fk FOREIGN KEY (user_assigned_status_id) REFERENCES public.generic_status(id);


--
-- Name: order_line_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT order_line_fk_1 FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: order_line_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT order_line_fk_2 FOREIGN KEY (order_id) REFERENCES public.purchase_order(id);


--
-- Name: order_line_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT order_line_fk_3 FOREIGN KEY (type_id) REFERENCES public.order_line_type(id);


--
-- Name: order_line_parent_line_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT order_line_parent_line_id_fk FOREIGN KEY (parent_line_id) REFERENCES public.order_line(id);


--
-- Name: order_meta_field_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_meta_field_map
    ADD CONSTRAINT order_meta_field_map_fk_1 FOREIGN KEY (order_id) REFERENCES public.purchase_order(id);


--
-- Name: order_meta_field_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_meta_field_map
    ADD CONSTRAINT order_meta_field_map_fk_2 FOREIGN KEY (meta_field_value_id) REFERENCES public.meta_field_value(id);


--
-- Name: order_period_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_period
    ADD CONSTRAINT order_period_fk_1 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: order_period_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_period
    ADD CONSTRAINT order_period_fk_2 FOREIGN KEY (unit_id) REFERENCES public.period_unit(id);


--
-- Name: order_primary_order_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order
    ADD CONSTRAINT order_primary_order_fk_1 FOREIGN KEY (primary_order_id) REFERENCES public.purchase_order(id);


--
-- Name: order_process_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_process
    ADD CONSTRAINT order_process_fk_1 FOREIGN KEY (order_id) REFERENCES public.purchase_order(id);


--
-- Name: parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_type
    ADD CONSTRAINT parent_id_fk FOREIGN KEY (parent_id) REFERENCES public.item_type(id);


--
-- Name: partner_commission_currency_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.partner_commission
    ADD CONSTRAINT "partner_commission_currency_id_FK" FOREIGN KEY (currency_id) REFERENCES public.currency(id);


--
-- Name: partner_fk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.partner
    ADD CONSTRAINT partner_fk_4 FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: partner_meta_field_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.partner_meta_field_map
    ADD CONSTRAINT partner_meta_field_map_fk_1 FOREIGN KEY (partner_id) REFERENCES public.partner(id);


--
-- Name: partner_meta_field_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.partner_meta_field_map
    ADD CONSTRAINT partner_meta_field_map_fk_2 FOREIGN KEY (meta_field_value_id) REFERENCES public.meta_field_value(id);


--
-- Name: partner_payout_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.partner_payout
    ADD CONSTRAINT partner_payout_fk_1 FOREIGN KEY (partner_id) REFERENCES public.partner(id);


--
-- Name: payment_authorization_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_authorization
    ADD CONSTRAINT payment_authorization_fk_1 FOREIGN KEY (payment_id) REFERENCES public.payment(id);


--
-- Name: payment_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_fk_1 FOREIGN KEY (ach_id) REFERENCES public.ach(id);


--
-- Name: payment_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_fk_2 FOREIGN KEY (currency_id) REFERENCES public.currency(id);


--
-- Name: payment_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_fk_3 FOREIGN KEY (payment_id) REFERENCES public.payment(id);


--
-- Name: payment_fk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_fk_4 FOREIGN KEY (credit_card_id) REFERENCES public.credit_card(id);


--
-- Name: payment_fk_5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_fk_5 FOREIGN KEY (result_id) REFERENCES public.payment_result(id);


--
-- Name: payment_fk_6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_fk_6 FOREIGN KEY (method_id) REFERENCES public.payment_method(id);


--
-- Name: payment_info_cheque_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_info_cheque
    ADD CONSTRAINT payment_info_cheque_fk_1 FOREIGN KEY (payment_id) REFERENCES public.payment(id);


--
-- Name: payment_information_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_information
    ADD CONSTRAINT "payment_information_FK1" FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: payment_information_FK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_information
    ADD CONSTRAINT "payment_information_FK2" FOREIGN KEY (payment_method_id) REFERENCES public.payment_method_type(id);


--
-- Name: payment_information_meta_fields_map_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_information_meta_fields_map
    ADD CONSTRAINT "payment_information_meta_fields_map_FK1" FOREIGN KEY (payment_information_id) REFERENCES public.payment_information(id);


--
-- Name: payment_information_meta_fields_map_FK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_information_meta_fields_map
    ADD CONSTRAINT "payment_information_meta_fields_map_FK2" FOREIGN KEY (meta_field_value_id) REFERENCES public.meta_field_value(id);


--
-- Name: payment_instrument_info_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_instrument_info
    ADD CONSTRAINT "payment_instrument_info_FK1" FOREIGN KEY (result_id) REFERENCES public.payment_result(id);


--
-- Name: payment_instrument_info_FK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_instrument_info
    ADD CONSTRAINT "payment_instrument_info_FK2" FOREIGN KEY (method_id) REFERENCES public.payment_method(id);


--
-- Name: payment_instrument_info_FK3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_instrument_info
    ADD CONSTRAINT "payment_instrument_info_FK3" FOREIGN KEY (instrument_id) REFERENCES public.payment_information(id);


--
-- Name: payment_instrument_info_FK4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_instrument_info
    ADD CONSTRAINT "payment_instrument_info_FK4" FOREIGN KEY (payment_id) REFERENCES public.payment(id);


--
-- Name: payment_invoice_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_invoice
    ADD CONSTRAINT payment_invoice_fk_1 FOREIGN KEY (invoice_id) REFERENCES public.invoice(id);


--
-- Name: payment_invoice_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_invoice
    ADD CONSTRAINT payment_invoice_fk_2 FOREIGN KEY (payment_id) REFERENCES public.payment(id);


--
-- Name: payment_meta_field_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_meta_field_map
    ADD CONSTRAINT payment_meta_field_map_fk_1 FOREIGN KEY (payment_id) REFERENCES public.payment(id);


--
-- Name: payment_meta_field_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_meta_field_map
    ADD CONSTRAINT payment_meta_field_map_fk_2 FOREIGN KEY (meta_field_value_id) REFERENCES public.meta_field_value(id);


--
-- Name: payment_method_account_type_map_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method_account_type_map
    ADD CONSTRAINT "payment_method_account_type_map_FK1" FOREIGN KEY (payment_method_id) REFERENCES public.payment_method_type(id);


--
-- Name: payment_method_account_type_map_FK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method_account_type_map
    ADD CONSTRAINT "payment_method_account_type_map_FK2" FOREIGN KEY (account_type_id) REFERENCES public.account_type(id);


--
-- Name: payment_method_meta_fields_map_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method_meta_fields_map
    ADD CONSTRAINT "payment_method_meta_fields_map_FK1" FOREIGN KEY (payment_method_id) REFERENCES public.payment_method_type(id);


--
-- Name: payment_method_meta_fields_map_FK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method_meta_fields_map
    ADD CONSTRAINT "payment_method_meta_fields_map_FK2" FOREIGN KEY (meta_field_id) REFERENCES public.meta_field_name(id);


--
-- Name: payment_method_template_meta_fields_map_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method_template_meta_fields_map
    ADD CONSTRAINT "payment_method_template_meta_fields_map_FK1" FOREIGN KEY (method_template_id) REFERENCES public.payment_method_template(id);


--
-- Name: payment_method_template_meta_fields_map_FK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method_template_meta_fields_map
    ADD CONSTRAINT "payment_method_template_meta_fields_map_FK2" FOREIGN KEY (meta_field_id) REFERENCES public.meta_field_name(id);


--
-- Name: payment_method_type_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method_type
    ADD CONSTRAINT "payment_method_type_FK1" FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: payment_method_type_FK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method_type
    ADD CONSTRAINT "payment_method_type_FK2" FOREIGN KEY (template_id) REFERENCES public.payment_method_template(id);


--
-- Name: pluggable_task_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pluggable_task
    ADD CONSTRAINT pluggable_task_fk_2 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: pluggable_task_parameter_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pluggable_task_parameter
    ADD CONSTRAINT pluggable_task_parameter_fk_1 FOREIGN KEY (task_id) REFERENCES public.pluggable_task(id);


--
-- Name: pluggable_task_type_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pluggable_task_type
    ADD CONSTRAINT pluggable_task_type_fk_1 FOREIGN KEY (category_id) REFERENCES public.pluggable_task_type_category(id);


--
-- Name: preference_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preference
    ADD CONSTRAINT preference_fk_1 FOREIGN KEY (type_id) REFERENCES public.preference_type(id);


--
-- Name: preference_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preference
    ADD CONSTRAINT preference_fk_2 FOREIGN KEY (table_id) REFERENCES public.jbilling_table(id);


--
-- Name: preference_type_vr_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preference_type
    ADD CONSTRAINT preference_type_vr_fk_1 FOREIGN KEY (validation_rule_id) REFERENCES public.validation_rule(id);


--
-- Name: process_run_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_run
    ADD CONSTRAINT process_run_fk_1 FOREIGN KEY (process_id) REFERENCES public.billing_process(id);


--
-- Name: process_run_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_run
    ADD CONSTRAINT process_run_fk_2 FOREIGN KEY (status_id) REFERENCES public.generic_status(id);


--
-- Name: process_run_total_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_run_total
    ADD CONSTRAINT process_run_total_fk_1 FOREIGN KEY (currency_id) REFERENCES public.currency(id);


--
-- Name: process_run_total_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_run_total
    ADD CONSTRAINT process_run_total_fk_2 FOREIGN KEY (process_run_id) REFERENCES public.process_run(id);


--
-- Name: process_run_total_pm_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_run_total_pm
    ADD CONSTRAINT process_run_total_pm_fk_1 FOREIGN KEY (payment_method_id) REFERENCES public.payment_method(id);


--
-- Name: process_run_user_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_run_user
    ADD CONSTRAINT process_run_user_fk_1 FOREIGN KEY (process_run_id) REFERENCES public.process_run(id);


--
-- Name: process_run_user_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_run_user
    ADD CONSTRAINT process_run_user_fk_2 FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: promotion_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_fk_1 FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: promotion_user_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_user_map
    ADD CONSTRAINT promotion_user_map_fk_1 FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: promotion_user_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_user_map
    ADD CONSTRAINT promotion_user_map_fk_2 FOREIGN KEY (promotion_id) REFERENCES public.promotion(id);


--
-- Name: purchase_order_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order
    ADD CONSTRAINT purchase_order_fk_1 FOREIGN KEY (currency_id) REFERENCES public.currency(id);


--
-- Name: purchase_order_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order
    ADD CONSTRAINT purchase_order_fk_2 FOREIGN KEY (billing_type_id) REFERENCES public.order_billing_type(id);


--
-- Name: purchase_order_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order
    ADD CONSTRAINT purchase_order_fk_3 FOREIGN KEY (period_id) REFERENCES public.order_period(id);


--
-- Name: purchase_order_fk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order
    ADD CONSTRAINT purchase_order_fk_4 FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: purchase_order_fk_5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order
    ADD CONSTRAINT purchase_order_fk_5 FOREIGN KEY (created_by) REFERENCES public.base_user(id);


--
-- Name: purchase_order_parent__order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order
    ADD CONSTRAINT purchase_order_parent__order_id_fk FOREIGN KEY (parent_order_id) REFERENCES public.purchase_order(id);


--
-- Name: purchase_order_statusId_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order
    ADD CONSTRAINT "purchase_order_statusId_fk" FOREIGN KEY (status_id) REFERENCES public.order_status(id);


--
-- Name: rating_unit_entity_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating_unit
    ADD CONSTRAINT "rating_unit_entity_id_FK" FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: report_map_entity_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_report_map
    ADD CONSTRAINT report_map_entity_id_fk FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: report_map_report_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_report_map
    ADD CONSTRAINT report_map_report_id_fk FOREIGN KEY (report_id) REFERENCES public.report(id);


--
-- Name: reseller_entityid_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reseller_entityid_map
    ADD CONSTRAINT reseller_entityid_map_fk_1 FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: reseller_entityid_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reseller_entityid_map
    ADD CONSTRAINT reseller_entityid_map_fk_2 FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: role_entity_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_entity_id_fk FOREIGN KEY (entity_id) REFERENCES public.entity(id);


--
-- Name: tab_configuration_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tab_configuration
    ADD CONSTRAINT tab_configuration_fk_1 FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: tab_configuration_tab_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tab_configuration_tab
    ADD CONSTRAINT tab_configuration_tab_fk_1 FOREIGN KEY (tab_id) REFERENCES public.tab(id);


--
-- Name: tab_configuration_tab_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tab_configuration_tab
    ADD CONSTRAINT tab_configuration_tab_fk_2 FOREIGN KEY (tab_configuration_id) REFERENCES public.tab_configuration(id);


--
-- Name: user_role_map_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role_map
    ADD CONSTRAINT user_role_map_fk_1 FOREIGN KEY (role_id) REFERENCES public.role(id);


--
-- Name: user_role_map_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role_map
    ADD CONSTRAINT user_role_map_fk_2 FOREIGN KEY (user_id) REFERENCES public.base_user(id);


--
-- Name: validation_rule_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meta_field_name
    ADD CONSTRAINT validation_rule_fk_1 FOREIGN KEY (validation_rule_id) REFERENCES public.validation_rule(id);


--
-- Name: validation_rule_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.validation_rule_attributes
    ADD CONSTRAINT validation_rule_fk_2 FOREIGN KEY (validation_rule_id) REFERENCES public.validation_rule(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

