-- -------------------------------------------------------------------------------------------
-- Consulta donde se obtiene los productos vendidos digitando tipo de documento y número de documento.
-- -------------------------------------------------------------------------------------------

SELECT product.product_name FROM product, sales, customer, bill
WHERE  product.product_id = sales.product_product_id
AND bill.customer_cust_id = customer.cust_id
AND sales.bill_bill_id = bill.bill_id
AND customer.type_ID_abreviation = 'TI'
AND customer.cust_number_ID = '123';


-- -------------------------------------------------------------------------------------------
-- Consulta productos por nombre, mostrando su proveedor.
-- -------------------------------------------------------------------------------------------
SELECT product_name, name_provider FROM product, providers
WHERE product.providers_providers_id = providers.providers_id AND product_name = 'LECHE';

