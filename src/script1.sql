-- -----------------------------------------------------
-- Schema tienda
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS tienda DEFAULT CHARACTER SET utf8 ;
USE tienda;

-- -----------------------------------------------------
-- Table type_ID
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS type_ID (
  abreviation VARCHAR(5) NOT NULL,
  type_ID_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (abreviation),
  UNIQUE INDEX abreviation_UNIQUE (abreviation ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table customer
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS customer (
  cust_id INT NOT NULL AUTO_INCREMENT,
  type_ID_abreviation VARCHAR(5) NOT NULL,
  cust_number_ID VARCHAR(11) NOT NULL,
  PRIMARY KEY (cust_id),
  UNIQUE INDEX cust_number_ID_UNIQUE (type_ID_abreviation ASC, cust_number_ID ASC) INVISIBLE,
  CONSTRAINT fk_customer_type_ID1
    FOREIGN KEY (type_ID_abreviation)
    REFERENCES type_ID (abreviation)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table providers
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS providers (
  providers_id INT NOT NULL AUTO_INCREMENT,
  NIT VARCHAR(80) NOT NULL,
  name_provider VARCHAR(45) NOT NULL,
  PRIMARY KEY (providers_id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table product
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS product (
  product_id INT NOT NULL AUTO_INCREMENT,
  providers_providers_id INT NOT NULL,
  product_name VARCHAR(30) NOT NULL,
  brand VARCHAR(45) NOT NULL,
  price DOUBLE NOT NULL,
  stock INT NOT NULL,
  PRIMARY KEY (product_id),
  INDEX fk_product_providers1_idx (providers_providers_id ASC) VISIBLE,
  CONSTRAINT fk_product_providers1
    FOREIGN KEY (providers_providers_id)
    REFERENCES providers (providers_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table bill
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS bill (
  bill_id INT NOT NULL AUTO_INCREMENT,
  customer_cust_id INT NOT NULL,
  date_bill DATE NOT NULL,
  total DOUBLE NULL,
  PRIMARY KEY (bill_id),
  INDEX fk_bill_customer1_idx (customer_cust_id ASC) VISIBLE,
  CONSTRAINT fk_bill_customer1
    FOREIGN KEY (customer_cust_id)
    REFERENCES customer (cust_id)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table sales
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS sales (
  sales_id INT NOT NULL AUTO_INCREMENT,
  bill_bill_id INT NOT NULL,
  product_product_id INT NOT NULL,
  amount_product DOUBLE NOT NULL,
  total DOUBLE NOT NULL,
  deleted_at TIMESTAMP,
  PRIMARY KEY (sales_id),
  UNIQUE INDEX `sales_id_UNIQUE` (sales_id ASC) VISIBLE,
  INDEX fk_sales_product1_idx (product_product_id ASC) VISIBLE,
  INDEX fk_sales_bill1_idx (bill_bill_id ASC) VISIBLE,
  CONSTRAINT fk_sales_product1
    FOREIGN KEY (product_product_id)
    REFERENCES product (product_id)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT fk_sales_bill1
    FOREIGN KEY (bill_bill_id)
    REFERENCES bill (bill_id)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;



-- -------------------------------------------------------------------------------------
-- Llenando las tablas con información para manipular la base de datos a nivel de datos.
-- -------------------------------------------------------------------------------------

INSERT INTO type_id(abreviation, type_ID_name)
VALUES ('CC', 'CEDULA DE CIUDADANIA'),
       ('CE', 'CEDULA DE EXTRANJERIA'),
       ('NIP', 'NUMERO DE IDENTIFICACION PERSONAL'),
       ('NIT', 'NUMERO DE IDENTIFICACION TRIBUTARIA'),
       ('TI', 'TARJETA DE IDENTIDAD'),
       ('PAP', 'PASAPORTE');

INSERT INTO customer(type_ID_abreviation, cust_number_ID)
VALUES ('CC','123'),
       ('TI','123'),
       ('CC','1234'),
       ('CC','12345'),
       ('TI', '12345');

INSERT INTO providers(NIT, name_provider)
VALUES ('123','ALPNIA'),
       ('1234','HUEVOS KIKES'),
       ('12345','COLANTA'),
       ('123456','MANUELA LUNA');

INSERT INTO product(providers_providers_id, product_name, brand, price, stock)
VALUES (2, 'HUEVOS','KIKES', 18000, 25),
       (1, 'QUESO', 'ALPINA', 8000, 80),
       (3, 'LECHE', 'COLANTA', 4500, 75),
       (4, 'BOLLOS DE COCO', 'MAÑE', 1200, 30),
       (3, 'AREQUIPE', 'COLANTA', 1500, 15);


INSERT INTO bill(customer_cust_id, date_bill, total)
VALUES (1, '2021-02-27',200500),
       (2, '2022-03-02',90000),
       (3, '2022-03-12',16000),
       (5, '2022-04-01',13500);

INSERT INTO sales(bill_bill_id, product_product_id, amount_product, total)
VALUES (1,1,10, 180000),
       (1,2,3,16000),
       (1,5,3,4500),
       (2,2,5, 90000),
       (3,2,3,16000),
       (4,3,3,13500);

-- -----------------------------------------------------------------------------------------
-- Realizando los dos borrados lógicos
-- -----------------------------------------------------------------------------------------

UPDATE  sales
SET deleted_at = now()
WHERE sales_id = 1;

UPDATE  sales
SET deleted_at = now()
WHERE sales_id = 3;

-- -----------------------------------------------------------------------------------------
-- Realizando los dos borrados fisicos
-- -----------------------------------------------------------------------------------------

DELETE FROM sales
WHERE sales_id = 5;

DELETE FROM sales
WHERE sales_id = 6;

-- -------------------------------------------------------------------------------------------
-- Modificando tres productos en su nombre y proveedor que los provee.
-- -------------------------------------------------------------------------------------------

UPDATE product
SET product_name = 'YOGURT', providers_providers_id = 1
WHERE product_name = 'LECHE';

UPDATE product
SET product_name = 'LECHE', providers_providers_id = 3
WHERE product_name = 'QUESO';

UPDATE product
SET product_name = 'MARGARINA', providers_providers_id = 1
WHERE product_name = 'AREQUIPE';