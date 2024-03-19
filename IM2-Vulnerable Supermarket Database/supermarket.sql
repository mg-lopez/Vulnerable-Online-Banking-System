--
-- PostgreSQL database dump
--
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = on;
-- Create roles
CREATE ROLE "Store_manager";
CREATE ROLE "HR_manager";
CREATE ROLE "admin";
CREATE ROLE "Finance_manager";
CREATE ROLE "Area_manager";
--
-- Name: customer; Type: SCHEMA; Schema: -; Owner: admin
--

CREATE SCHEMA customer;
ALTER SCHEMA customer OWNER TO admin;
--
-- TOC entry 9 (class 2615 OID 82776)
-- Name: employee; Type: SCHEMA; Schema: -; Owner: admin
--

CREATE SCHEMA employee;
ALTER SCHEMA employee OWNER TO admin;
--
-- TOC entry 8 (class 2615 OID 82780)
-- Name: inventory; Type: SCHEMA; Schema: -; Owner: admin
--

CREATE SCHEMA inventory;
ALTER SCHEMA inventory OWNER TO admin;
--
-- TOC entry 7 (class 2615 OID 82778)
-- Name: product; Type: SCHEMA; Schema: -; Owner: admin
--

CREATE SCHEMA product;
ALTER SCHEMA product OWNER TO admin;
--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it
ALTER SCHEMA public OWNER TO postgres;
--
-- TOC entry 233 (class 1255 OID 91254)
-- Name: audit_trigger_func(); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.audit_trigger_func() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN IF (TG_OP = 'DELETE') THEN
INSERT INTO audit_table (user_name, event_type, table_name, old_data)
VALUES (current_user, TG_OP, TG_TABLE_NAME, OLD::text);
RETURN OLD;
ELSIF (TG_OP = 'UPDATE') THEN
INSERT INTO audit_table (
        user_name,
        event_type,
        table_name,
        old_data,
        new_data
    )
VALUES (
        current_user,
        TG_OP,
        TG_TABLE_NAME,
        OLD::text,
        NEW::text
    );
RETURN NEW;
ELSIF (TG_OP = 'INSERT') THEN
INSERT INTO audit_table (user_name, event_type, table_name, new_data)
VALUES (current_user, TG_OP, TG_TABLE_NAME, NEW::text);
RETURN NEW;
END IF;
RETURN NULL;
END;
$$;
ALTER FUNCTION public.audit_trigger_func() OWNER TO admin;
SET default_tablespace = '';
SET default_table_access_method = heap;
--
-- TOC entry 224 (class 1259 OID 82871)
-- Name: Customer; Type: TABLE; Schema: customer; Owner: admin
--

CREATE TABLE customer."Customer" (
    customer_id integer NOT NULL,
    name text,
    address text,
    phone_number text,
    email text
);
ALTER TABLE customer."Customer" OWNER TO admin;
--
-- TOC entry 225 (class 1259 OID 82878)
-- Name: Order; Type: TABLE; Schema: customer; Owner: admin
--

CREATE TABLE customer."Order" (
    order_id integer NOT NULL,
    customer_id integer,
    order_date date,
    total_price numeric(10, 2),
    store_id integer
);
ALTER TABLE customer."Order" OWNER TO admin;
--
-- TOC entry 214 (class 1259 OID 82785)
-- Name: Employee; Type: TABLE; Schema: employee; Owner: admin
--

CREATE TABLE employee."Employee" (
    emp_id integer NOT NULL,
    name character(255),
    address character(255),
    date_of_birth date,
    sort_code character(10),
    bank_account_number character(20),
    salary numeric(10, 2)
);
ALTER TABLE employee."Employee" OWNER TO admin;
--
-- TOC entry 215 (class 1259 OID 82793)
-- Name: EmployeeJobDetails; Type: TABLE; Schema: employee; Owner: admin
--

CREATE TABLE employee."EmployeeJobDetails" (
    emp_id integer NOT NULL,
    area_id integer,
    store_id integer,
    department_id integer,
    job_role text NOT NULL
);
ALTER TABLE employee."EmployeeJobDetails" OWNER TO admin;
--
-- TOC entry 213 (class 1259 OID 82784)
-- Name: Employee_emp_id_seq; Type: SEQUENCE; Schema: employee; Owner: admin
--

CREATE SEQUENCE employee."Employee_emp_id_seq" AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE employee."Employee_emp_id_seq" OWNER TO admin;
--
-- TOC entry 3481 (class 0 OID 0)
-- Dependencies: 213
-- Name: Employee_emp_id_seq; Type: SEQUENCE OWNED BY; Schema: employee; Owner: admin
--

ALTER SEQUENCE employee."Employee_emp_id_seq" OWNED BY employee."Employee".emp_id;
--
-- TOC entry 221 (class 1259 OID 82830)
-- Name: Area; Type: TABLE; Schema: inventory; Owner: admin
--

CREATE TABLE inventory."Area" (
    area_id integer NOT NULL,
    area_name text,
    manager_id integer
);
ALTER TABLE inventory."Area" OWNER TO admin;
--
-- TOC entry 219 (class 1259 OID 82815)
-- Name: Inventory; Type: TABLE; Schema: inventory; Owner: admin
--

CREATE TABLE inventory."Inventory" (
    inventory_id integer NOT NULL,
    area_id integer,
    product_id integer,
    quantity integer NOT NULL
);
ALTER TABLE inventory."Inventory" OWNER TO admin;
--
-- TOC entry 218 (class 1259 OID 82814)
-- Name: Inventory_inventory_id_seq; Type: SEQUENCE; Schema: inventory; Owner: admin
--

CREATE SEQUENCE inventory."Inventory_inventory_id_seq" AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE inventory."Inventory_inventory_id_seq" OWNER TO admin;
--
-- Name: Inventory_inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: inventory; Owner: admin
--

ALTER SEQUENCE inventory."Inventory_inventory_id_seq" OWNED BY inventory."Inventory".inventory_id;
--
-- Name: Product; Type: TABLE; Schema: inventory; Owner: admin
--

CREATE TABLE inventory."Product" (
    product_id integer NOT NULL,
    product_name text,
    category text,
    price numeric(10, 2) NOT NULL
);
ALTER TABLE inventory."Product" OWNER TO admin;
--
-- TOC entry 223 (class 1259 OID 82858)
-- Name: Store; Type: TABLE; Schema: inventory; Owner: admin
--

CREATE TABLE inventory."Store" (
    store_id integer NOT NULL,
    store_name text NOT NULL,
    location text NOT NULL,
    contact_number text NOT NULL
);
ALTER TABLE inventory."Store" OWNER TO admin;
--
-- TOC entry 222 (class 1259 OID 82857)
-- Name: Store_store_id_seq; Type: SEQUENCE; Schema: inventory; Owner: admin
--

CREATE SEQUENCE inventory."Store_store_id_seq" AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE inventory."Store_store_id_seq" OWNER TO admin;
--
-- Name: Store_store_id_seq; Type: SEQUENCE OWNED BY; Schema: inventory; Owner: admin
--

ALTER SEQUENCE inventory."Store_store_id_seq" OWNED BY inventory."Store".store_id;
--
-- TOC entry 217 (class 1259 OID 82806)
-- Name: Product; Type: TABLE; Schema: product; Owner: admin
--

CREATE TABLE product."Product" (
    product_id integer NOT NULL,
    name text NOT NULL,
    category text NOT NULL,
    price numeric(10, 2) NOT NULL
);
ALTER TABLE product."Product" OWNER TO admin;
--
-- TOC entry 216 (class 1259 OID 82805)
-- Name: Product_product_id_seq; Type: SEQUENCE; Schema: product; Owner: admin
--

CREATE SEQUENCE product."Product_product_id_seq" AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE product."Product_product_id_seq" OWNER TO admin;
--
-- TOC entry 3489 (class 0 OID 0)
-- Dependencies: 216
-- Name: Product_product_id_seq; Type: SEQUENCE OWNED BY; Schema: product; Owner: admin
--

ALTER SEQUENCE product."Product_product_id_seq" OWNED BY product."Product".product_id;
--
-- TOC entry 232 (class 1259 OID 91245)
-- Name: audit_table; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.audit_table (
    event_id integer NOT NULL,
    event_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    user_name text,
    event_type text,
    table_name text,
    old_data text,
    new_data text
);
ALTER TABLE public.audit_table OWNER TO admin;
--
-- TOC entry 231 (class 1259 OID 91244)
-- Name: audit_table_event_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.audit_table_event_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.audit_table_event_id_seq OWNER TO admin;
--
-- Name: audit_table_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.audit_table_event_id_seq OWNED BY public.audit_table.event_id;
--
-- TOC entry 3274 (class 2604 OID 82788)
-- Name: Employee emp_id; Type: DEFAULT; Schema: employee; Owner: admin
--

ALTER TABLE ONLY employee."Employee"
ALTER COLUMN emp_id
SET DEFAULT nextval('employee."Employee_emp_id_seq"'::regclass);
--
-- TOC entry 3276 (class 2604 OID 82818)
-- Name: Inventory inventory_id; Type: DEFAULT; Schema: inventory; Owner: admin
--

ALTER TABLE ONLY inventory."Inventory"
ALTER COLUMN inventory_id
SET DEFAULT nextval(
        'inventory."Inventory_inventory_id_seq"'::regclass
    );
--
-- TOC entry 3277 (class 2604 OID 82861)
-- Name: Store store_id; Type: DEFAULT; Schema: inventory; Owner: admin
--

ALTER TABLE ONLY inventory."Store"
ALTER COLUMN store_id
SET DEFAULT nextval('inventory."Store_store_id_seq"'::regclass);
--
-- TOC entry 3275 (class 2604 OID 82809)
-- Name: Product product_id; Type: DEFAULT; Schema: product; Owner: admin
--

ALTER TABLE ONLY product."Product"
ALTER COLUMN product_id
SET DEFAULT nextval('product."Product_product_id_seq"'::regclass);
--
-- TOC entry 3278 (class 2604 OID 91248)
-- Name: audit_table event_id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.audit_table
ALTER COLUMN event_id
SET DEFAULT nextval('public.audit_table_event_id_seq'::regclass);
--
-- TOC entry 3297 (class 2606 OID 82877)
-- Name: Customer Customer_pkey; Type: CONSTRAINT; Schema: customer; Owner: admin
--

ALTER TABLE ONLY customer."Customer"
ADD CONSTRAINT "Customer_pkey" PRIMARY KEY (customer_id);
--
-- TOC entry 3299 (class 2606 OID 82882)
-- Name: Order Order_pkey; Type: CONSTRAINT; Schema: customer; Owner: admin
--

ALTER TABLE ONLY customer."Order"
ADD CONSTRAINT "Order_pkey" PRIMARY KEY (order_id);
--
-- TOC entry 3283 (class 2606 OID 82799)
-- Name: EmployeeJobDetails EmployeeJobDetails_pkey; Type: CONSTRAINT; Schema: employee; Owner: admin
--

ALTER TABLE ONLY employee."EmployeeJobDetails"
ADD CONSTRAINT "EmployeeJobDetails_pkey" PRIMARY KEY (emp_id);
--
-- TOC entry 3281 (class 2606 OID 82792)
-- Name: Employee Employee_pkey; Type: CONSTRAINT; Schema: employee; Owner: admin
--

ALTER TABLE ONLY employee."Employee"
ADD CONSTRAINT "Employee_pkey" PRIMARY KEY (emp_id);
--
-- TOC entry 3293 (class 2606 OID 82836)
-- Name: Area Area_pkey; Type: CONSTRAINT; Schema: inventory; Owner: admin
--

ALTER TABLE ONLY inventory."Area"
ADD CONSTRAINT "Area_pkey" PRIMARY KEY (area_id);
--
-- TOC entry 3287 (class 2606 OID 82820)
-- Name: Inventory Inventory_pkey; Type: CONSTRAINT; Schema: inventory; Owner: admin
--

ALTER TABLE ONLY inventory."Inventory"
ADD CONSTRAINT "Inventory_pkey" PRIMARY KEY (inventory_id);
--
-- TOC entry 3291 (class 2606 OID 82829)
-- Name: Product Product_pkey; Type: CONSTRAINT; Schema: inventory; Owner: admin
--

ALTER TABLE ONLY inventory."Product"
ADD CONSTRAINT "Product_pkey" PRIMARY KEY (product_id);
--
-- TOC entry 3295 (class 2606 OID 82865)
-- Name: Store Store_pkey; Type: CONSTRAINT; Schema: inventory; Owner: admin
--

ALTER TABLE ONLY inventory."Store"
ADD CONSTRAINT "Store_pkey" PRIMARY KEY (store_id);
--
-- TOC entry 3289 (class 2606 OID 82822)
-- Name: Inventory unique_area_product; Type: CONSTRAINT; Schema: inventory; Owner: admin
--

ALTER TABLE ONLY inventory."Inventory"
ADD CONSTRAINT unique_area_product UNIQUE (area_id, product_id);
--
-- TOC entry 3285 (class 2606 OID 82813)
-- Name: Product Product_pkey; Type: CONSTRAINT; Schema: product; Owner: admin
--

ALTER TABLE ONLY product."Product"
ADD CONSTRAINT "Product_pkey" PRIMARY KEY (product_id);
--
-- TOC entry 3301 (class 2606 OID 91253)
-- Name: audit_table audit_table_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.audit_table
ADD CONSTRAINT audit_table_pkey PRIMARY KEY (event_id);
--
-- Name: Employee audit_trigger; Type: TRIGGER; Schema: employee; Owner: admin
--

CREATE TRIGGER audit_trigger
AFTER
INSERT
    OR DELETE
    OR
UPDATE ON employee."Employee" FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_func();
--
-- TOC entry 3308 (class 2606 OID 82883)
-- Name: Order customer_id; Type: FK CONSTRAINT; Schema: customer; Owner: admin
--

ALTER TABLE ONLY customer."Order"
ADD CONSTRAINT customer_id FOREIGN KEY (customer_id) REFERENCES customer."Customer"(customer_id);
--
-- TOC entry 3309 (class 2606 OID 82888)
-- Name: Order store_id; Type: FK CONSTRAINT; Schema: customer; Owner: admin
--

ALTER TABLE ONLY customer."Order"
ADD CONSTRAINT store_id FOREIGN KEY (store_id) REFERENCES inventory."Store"(store_id);
--

ALTER TABLE ONLY inventory."Inventory"
ADD CONSTRAINT "Inventory_product" FOREIGN KEY (product_id) REFERENCES inventory."Product"(product_id) NOT VALID;
--
-- TOC entry 3306 (class 2606 OID 82842)
-- Name: Inventory area_inventory; Type: FK CONSTRAINT; Schema: inventory; Owner: admin
--

ALTER TABLE ONLY inventory."Inventory"
ADD CONSTRAINT area_inventory FOREIGN KEY (area_id) REFERENCES inventory."Area"(area_id) NOT VALID;
--
-- TOC entry 3307 (class 2606 OID 82837)
-- Name: Area area_manager; Type: FK CONSTRAINT; Schema: inventory; Owner: admin
--

ALTER TABLE ONLY inventory."Area"
ADD CONSTRAINT area_manager FOREIGN KEY (manager_id) REFERENCES employee."Employee"(emp_id);
--
-- TOC entry 3455 (class 0 OID 82785)
-- Dependencies: 214
-- Name: Employee; Type: ROW SECURITY; Schema: employee; Owner: admin
--

ALTER TABLE employee."Employee" ENABLE ROW LEVEL SECURITY;
--
-- Name: Employee admin_policy; Type: POLICY; Schema: employee; Owner: admin
--

CREATE POLICY admin_policy ON employee."Employee" FOR
SELECT USING (
        (
            emp_id IN (
                SELECT "EmployeeJobDetails".emp_id
                FROM employee."EmployeeJobDetails"
                WHERE ("EmployeeJobDetails".job_role = 'admin'::text)
            )
        )
    );
--
-- TOC entry 3457 (class 3256 OID 82961)
-- Name: Employee area_manager_policy; Type: POLICY; Schema: employee; Owner: admin
--

CREATE POLICY area_manager_policy ON employee."Employee" FOR
SELECT USING (
        (
            emp_id IN (
                SELECT "EmployeeJobDetails".emp_id
                FROM employee."EmployeeJobDetails"
                WHERE (
                        "EmployeeJobDetails".job_role = 'Area_manager'::text
                    )
            )
        )
    );
--
-- TOC entry 3456 (class 3256 OID 82960)
-- Name: Employee finance_manager_policy; Type: POLICY; Schema: employee; Owner: admin
--

CREATE POLICY finance_manager_policy ON employee."Employee" FOR
SELECT USING (
        (
            emp_id IN (
                SELECT "EmployeeJobDetails".emp_id
                FROM employee."EmployeeJobDetails"
                WHERE (
                        "EmployeeJobDetails".job_role = 'Finance_manager'::text
                    )
            )
        )
    );
--
-- TOC entry 3459 (class 3256 OID 82959)
-- Name: Employee hr_manager_policy; Type: POLICY; Schema: employee; Owner: admin
--
CREATE POLICY hr_manager_policy ON employee."Employee" FOR
SELECT USING (
        (
            emp_id IN (
                SELECT "EmployeeJobDetails".emp_id
                FROM employee."EmployeeJobDetails"
                WHERE (
                        "EmployeeJobDetails".job_role = 'HR_manager'::text
                    )
            )
        )
    );
--
-- TOC entry 3458 (class 3256 OID 82947)
-- Name: Employee store_manager_policy; Type: POLICY; Schema: employee; Owner: admin
--

CREATE POLICY store_manager_policy ON employee."Employee" FOR
SELECT USING (
        (
            emp_id IN (
                SELECT "EmployeeJobDetails".emp_id
                FROM employee."EmployeeJobDetails"
                WHERE (
                        "EmployeeJobDetails".job_role = 'Store_manager'::text
                    )
            )
        )
    );
--
-- Name: SCHEMA customer; Type: ACL; Schema: -; Owner: admin
--

GRANT USAGE ON SCHEMA customer TO "Store_manager";
GRANT USAGE ON SCHEMA customer TO "HR_manager";
GRANT USAGE ON SCHEMA customer TO "Finance_manager";
GRANT USAGE ON SCHEMA customer TO "Area_manager";
--
-- Name: SCHEMA employee; Type: ACL; Schema: -; Owner: admin
--

GRANT ALL ON SCHEMA employee TO "HR_manager";
GRANT USAGE ON SCHEMA employee TO "Store_manager";
GRANT ALL ON SCHEMA employee TO "Finance_manager";
GRANT ALL ON SCHEMA employee TO "Area_manager";
--
-- Name: SCHEMA inventory; Type: ACL; Schema: -; Owner: admin
--

GRANT USAGE ON SCHEMA inventory TO "Store_manager";
GRANT USAGE ON SCHEMA inventory TO "HR_manager";
GRANT USAGE ON SCHEMA inventory TO "Finance_manager";
GRANT USAGE ON SCHEMA inventory TO "Area_manager";
--
-- Name: SCHEMA product; Type: ACL; Schema: -; Owner: admin
--

GRANT USAGE ON SCHEMA product TO "Store_manager";
GRANT USAGE ON SCHEMA product TO "HR_manager";
GRANT USAGE ON SCHEMA product TO "Finance_manager";
GRANT USAGE ON SCHEMA product TO "Area_manager";
--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public
FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
--
-- Name: TABLE "Customer"; Type: ACL; Schema: customer; Owner: admin
--

GRANT SELECT ON TABLE customer."Customer" TO "Store_manager";
GRANT SELECT ON TABLE customer."Customer" TO "HR_manager";
GRANT SELECT,
    UPDATE ON TABLE customer."Customer" TO "Finance_manager";
GRANT SELECT ON TABLE customer."Customer" TO "Area_manager";
--
-- Name: TABLE "Order"; Type: ACL; Schema: customer; Owner: admin
--

GRANT SELECT ON TABLE customer."Order" TO "Store_manager";
GRANT SELECT ON TABLE customer."Order" TO "HR_manager";
GRANT SELECT,
    UPDATE ON TABLE customer."Order" TO "Finance_manager";
GRANT SELECT ON TABLE customer."Order" TO "Area_manager";
--
-- Name: TABLE "Employee"; Type: ACL; Schema: employee; Owner: admin
--

REVOKE ALL ON TABLE employee."Employee"
FROM admin;
GRANT INSERT,
    REFERENCES,
    DELETE,
    TRIGGER,
    TRUNCATE,
    UPDATE ON TABLE employee."Employee" TO admin;
GRANT UPDATE ON TABLE employee."Employee" TO "HR_manager";
GRANT UPDATE ON TABLE employee."Employee" TO "Finance_manager";
GRANT UPDATE ON TABLE employee."Employee" TO "Area_manager";
GRANT UPDATE ON TABLE employee."Employee" TO "Store_manager";
--
-- Name: COLUMN "Employee".name; Type: ACL; Schema: employee; Owner: admin
--

GRANT SELECT(name) ON TABLE employee."Employee" TO admin;
GRANT SELECT(name) ON TABLE employee."Employee" TO "Store_manager";
GRANT SELECT(name) ON TABLE employee."Employee" TO "HR_manager";
GRANT SELECT(name) ON TABLE employee."Employee" TO "Finance_manager";
GRANT SELECT(name) ON TABLE employee."Employee" TO "Area_manager";
--
-- Name: COLUMN "Employee".address; Type: ACL; Schema: employee; Owner: admin
--

GRANT SELECT(address) ON TABLE employee."Employee" TO "Store_manager";
GRANT SELECT(address) ON TABLE employee."Employee" TO "HR_manager";
GRANT SELECT(address) ON TABLE employee."Employee" TO "Finance_manager";
GRANT SELECT(address) ON TABLE employee."Employee" TO "Area_manager";
--
-- Name: COLUMN "Employee".date_of_birth; Type: ACL; Schema: employee; Owner: admin
--

GRANT SELECT(date_of_birth) ON TABLE employee."Employee" TO "HR_manager";
GRANT SELECT(date_of_birth) ON TABLE employee."Employee" TO "Finance_manager";
--
-- Name: COLUMN "Employee".sort_code; Type: ACL; Schema: employee; Owner: admin
--

GRANT SELECT(sort_code) ON TABLE employee."Employee" TO "Finance_manager";
--
-- Name: COLUMN "Employee".bank_account_number; Type: ACL; Schema: employee; Owner: admin
--

GRANT SELECT(bank_account_number) ON TABLE employee."Employee" TO "Finance_manager";
--
-- Name: COLUMN "Employee".salary; Type: ACL; Schema: employee; Owner: admin
--

GRANT SELECT(salary) ON TABLE employee."Employee" TO "HR_manager";
GRANT SELECT(salary) ON TABLE employee."Employee" TO "Finance_manager";
--
-- Name: TABLE "EmployeeJobDetails"; Type: ACL; Schema: employee; Owner: admin
--

GRANT SELECT,
    UPDATE ON TABLE employee."EmployeeJobDetails" TO "Store_manager";
GRANT SELECT,
    UPDATE ON TABLE employee."EmployeeJobDetails" TO "HR_manager";
GRANT SELECT,
    UPDATE ON TABLE employee."EmployeeJobDetails" TO "Finance_manager";
GRANT SELECT,
    UPDATE ON TABLE employee."EmployeeJobDetails" TO "Area_manager";
--
-- TOC entry 3482 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE "Area"; Type: ACL; Schema: inventory; Owner: admin
--

GRANT SELECT ON TABLE inventory."Area" TO "Store_manager";
GRANT SELECT ON TABLE inventory."Area" TO "HR_manager";
GRANT SELECT,
    UPDATE ON TABLE inventory."Area" TO "Finance_manager";
GRANT SELECT ON TABLE inventory."Area" TO "Area_manager";
--
-- Name: TABLE "Inventory"; Type: ACL; Schema: inventory; Owner: admin
--

GRANT SELECT ON TABLE inventory."Inventory" TO "Store_manager";
GRANT SELECT ON TABLE inventory."Inventory" TO "HR_manager";
GRANT SELECT,
    UPDATE ON TABLE inventory."Inventory" TO "Finance_manager";
GRANT SELECT ON TABLE inventory."Inventory" TO "Area_manager";
--
-- Name: TABLE "Product"; Type: ACL; Schema: inventory; Owner: admin
--

GRANT SELECT ON TABLE inventory."Product" TO "Store_manager";
GRANT SELECT ON TABLE inventory."Product" TO "HR_manager";
GRANT SELECT,
    UPDATE ON TABLE inventory."Product" TO "Finance_manager";
GRANT SELECT ON TABLE inventory."Product" TO "Area_manager";
--
-- Name: TABLE "Store"; Type: ACL; Schema: inventory; Owner: admin
--

GRANT SELECT ON TABLE inventory."Store" TO "Store_manager";
GRANT SELECT ON TABLE inventory."Store" TO "HR_manager";
GRANT SELECT,
    UPDATE ON TABLE inventory."Store" TO "Finance_manager";
GRANT SELECT ON TABLE inventory."Store" TO "Area_manager";
--
-- Name: TABLE "Product"; Type: ACL; Schema: product; Owner: admin
--

GRANT SELECT ON TABLE product."Product" TO "Store_manager";
GRANT SELECT ON TABLE product."Product" TO "HR_manager";
GRANT SELECT,
    UPDATE ON TABLE product."Product" TO "Finance_manager";
GRANT SELECT ON TABLE product."Product" TO "Area_manager";
--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: customer; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA customer
GRANT SELECT ON TABLES TO "Store_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA customer
GRANT SELECT ON TABLES TO "HR_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA customer
GRANT SELECT,
    UPDATE ON TABLES TO "Finance_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA customer
GRANT SELECT ON TABLES TO "Area_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA customer
GRANT SELECT,
    INSERT,
    DELETE,
    UPDATE ON TABLES TO admin;
--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: employee; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA employee
GRANT SELECT,
    UPDATE ON TABLES TO "Store_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA employee
GRANT SELECT,
    UPDATE ON TABLES TO "HR_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA employee
GRANT SELECT,
    UPDATE ON TABLES TO "Finance_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA employee
GRANT SELECT,
    UPDATE ON TABLES TO "Area_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA employee
GRANT SELECT,
    INSERT,
    DELETE,
    UPDATE ON TABLES TO admin;
--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: inventory; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA inventory
GRANT SELECT ON TABLES TO "Store_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA inventory
GRANT SELECT ON TABLES TO "HR_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA inventory
GRANT SELECT,
    UPDATE ON TABLES TO "Finance_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA inventory
GRANT SELECT ON TABLES TO "Area_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA inventory
GRANT SELECT,
    INSERT,
    DELETE,
    UPDATE ON TABLES TO admin;
--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: product; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA product
GRANT SELECT ON TABLES TO "Store_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA product
GRANT SELECT ON TABLES TO "HR_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA product
GRANT SELECT,
    UPDATE ON TABLES TO "Finance_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA product
GRANT SELECT ON TABLES TO "Area_manager";
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA product
GRANT SELECT,
    INSERT,
    DELETE,
    UPDATE ON TABLES TO admin;
-- Enable RLS
ALTER TABLE employee."Employee" ENABLE ROW LEVEL SECURITY;
-- Grant specific column access
REVOKE ALL ON employee."Employee"
FROM "Store_manager";
REVOKE ALL ON employee."Employee"
FROM "HR_manager";
REVOKE ALL ON employee."Employee"
FROM "Finance_manager";
REVOKE ALL ON employee."Employee"
FROM "Area_manager";
REVOKE ALL ON employee."Employee"
FROM admin;
GRANT SELECT(name, address) ON employee."Employee" TO "Store_manager";
GRANT SELECT(name, address, date_of_birth, salary) ON employee."Employee" TO "HR_manager";
GRANT SELECT(name) ON employee."Employee" TO admin;
GRANT SELECT(
        name,
        address,
        date_of_birth,
        sort_code,
        bank_account_number,
        salary
    ) ON employee."Employee" TO "Finance_manager";
GRANT SELECT(name, address) ON employee."Employee" TO "Area_manager";
--
-- PostgreSQL database dump complete