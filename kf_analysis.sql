CREATE TABLE
  `rakamin-kf-analytics-510902.Kimia_Farma.kf_analysis` AS
SELECT
    t.transaction_id,
    t.date,
    t.branch_id,
    b.branch_name,
    b.kota,
    b.provinsi,
    b.rating AS rating_cabang,
    t.customer_name,
    t.product_id,
    p.product_name,
    -- Harga produk
    p.price AS actual_price,
    -- Persentase diskon
    t.discount_percentage,
    -- Persentase gross laba berdasarkan harga produk
    CASE
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price <= 100000 THEN 0.15
        WHEN p.price <= 300000 THEN 0.20
        WHEN p.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,
    -- Nett sales: harga setelah diskon
    p.price * (1 - t.discount_percentage) AS nett_sales,

    -- Nett profit: nett sales dikali persentase gross laba
    (
        p.price * (1 - t.discount_percentage)
    ) *
    CASE
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price <= 100000 THEN 0.15
        WHEN p.price <= 300000 THEN 0.20
        WHEN p.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS nett_profit,
    -- Rating transaksi
    t.rating AS rating_transaksi
FROM
    `rakamin-kf-analytics-510902.Kimia_Farma.kf_final_transaction` AS t
LEFT JOIN
    `rakamin-kf-analytics-510902.Kimia_Farma.kf_products` AS p
    ON t.product_id = p.product_id

LEFT JOIN
    `rakamin-kf-analytics-510902.Kimia_Farma.kf_kantor_cabang` AS b
    ON t.branch_id = b.branch_id;
