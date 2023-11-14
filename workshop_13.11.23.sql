--86. a.Bu ülkeler hangileri..?
SELECT DISTINCT country
FROM customers;

--87. En Pahalı 5 ürün
SELECT *
FROM products
ORDER BY unit_price DESC
LIMIT 5;

--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
SELECT COUNT(*) AS "Sipariş Sayısı"
FROM orders
WHERE customer_id = 'ALFKI';

--89. Ürünlerimin toplam maliyeti
SELECT SUM(unit_price * units_in_stock) AS "Toplam Maliyet"
FROM products;

--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
SELECT SUM(quantity * unit_price) AS "Toplam Satış Miktarı"
FROM order_details;

--91. Ortalama Ürün Fiyatım
SELECT AVG(unit_price) AS "Ortalama Fiyat"
FROM products;

--92. En Pahalı Ürünün Adı
SELECT product_name
FROM products
ORDER BY unit_price
LIMIT 1;

--93. En az kazandıran sipariş
SELECT order_id, SUM(unit_price * quantity) AS total_cost
FROM order_details
GROUP BY order_id
ORDER BY total_cost ASC
LIMIT 1;

--94. Müşterilerimin içinde en uzun isimli müşteri
SELECT *
FROM customers
ORDER BY LENGTH(contact_name) DESC
LIMIT 5;

--95. Çalışanlarımın Ad, Soyad ve Yaşları
SELECT first_name || ' ' || last_name AS "Ad Soyad", DATE_PART('year', CURRENT_DATE) - DATE_PART('year', birth_date) AS "Yaş" 
FROM employees;

--96. Hangi üründen toplam kaç adet alınmış..?
SELECT product_id, SUM(quantity) AS total_quantity
FROM order_details
GROUP BY product_id;

--97. Hangi siparişte toplam ne kadar kazanmışım..?
SELECT order_id, SUM(unit_price * quantity) total_profit
FROM order_details
GROUP BY order_id;

--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
SELECT p.category_id, c.category_name, COUNT(*) AS total_product_quantities
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
GROUP BY p.category_id, c.category_name;

--99. 1000 Adetten fazla satılan ürünler?
SELECT od.product_id, p.product_name, SUM(od.quantity) AS total_sold
FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
GROUP BY od.product_id,p.product_name
HAVING SUM(od.quantity) > 1000;

--100. Hangi Müşterilerim hiç sipariş vermemiş..?
SELECT c.customer_id, c.company_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

--101. Hangi tedarikçi hangi ürünü sağlıyor ?
SELECT s.company_name AS company, p.product_name
FROM products p
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id;

--102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?
SELECT o.order_id,o.shipped_date,s.company_name
FROM orders o
INNER JOIN shippers s ON o.ship_via = s.shipper_id;

--103. Hangi siparişi hangi müşteri verir..?
SELECT c.contact_name, o.order_id
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

--104. Hangi çalışan, toplam kaç sipariş almış..?
SELECT e.first_name || ' ' || e.last_name AS "Çalışan Ad Soyad", COUNT(o.order_id) AS "Satış Sayısı"
FROM employees e
INNER JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.first_name, e.last_name;

--105. En fazla siparişi kim almış..?
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS "Ad Soyad", COUNT(o.order_id) AS "Toplam Sipariş Sayısı"
FROM employees e
INNER JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY COUNT(o.order_id) DESC
LIMIT 1;

--106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
SELECT o.order_id, e.first_name || ' ' || e.last_name AS "Çalışan Ad Soyad" , c.company_name
FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN customers c ON o.customer_id = c.customer_id;

--107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?
SELECT p.product_name AS "Ürün Adı", c.category_name AS "Kategori", s.company_name AS "Tedarikçi Adı"
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id;

--108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte, hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış, 
--hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış
SELECT 
	o.order_id AS "Sipariş ID",
	c.customer_id AS "Müşteri ID",
	c.contact_name || ' (' || c.company_name || ')' AS "Müşteri ve B.O Şirket",
	e.employee_id AS "Çalışan ID",
	e.first_name || ' ' || e.last_name AS "Çalışan Ad Soyad",
	o.order_date AS "Sipariş Tarihi",
	s.company_name AS "Kargo Şirketi",
	od.quantity AS "Adet Sayısı",
	od.unit_price AS "Fiyatı",
	cg.category_name AS "Kategori",
	sp.company_name AS "Tedarikçi"
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN shippers s ON o.ship_via = s.shipper_id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories cg ON p.category_id = cg.category_id
INNER JOIN suppliers sp ON p.supplier_id = sp.supplier_id;

--109. Altında ürün bulunmayan kategoriler
SELECT c.category_id, c.category_name
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
WHERE p.product_id IS NULL;

--110. Manager ünvanına sahip tüm müşterileri listeleyiniz.
SELECT *
FROM customers
WHERE contact_title LIKE '%Manager%';

--111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
SELECT *
FROM customers
WHERE company_name LIKE 'FR___';

--112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
SELECT *
FROM customers
WHERE phone LIKE '%(171)%';

--113. Birimdeki Miktar alanında boxes geçen tüm ürünleri listeleyiniz.
SELECT *
FROM products
WHERE quantity_per_unit LIKE '%boxes%';

--114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
SELECT contact_name AS "Müşteri Adı", phone AS "Telefon"
FROM customers
WHERE country IN ('France', 'Germany') AND contact_title LIKE '%Manager%';

--115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 10;

--116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
SELECT *
FROM customers
ORDER BY country, city;

--117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
SELECT first_name || ' ' || last_name AS "Ad Soyad", 
DATE_PART('year', CURRENT_DATE) - DATE_PART('year', birth_date) AS "Yaş" 
FROM employees;

--118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
SELECT *
FROM orders
WHERE shipped_date IS NULL AND CURRENT_DATE - order_date > 35;

--119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
SELECT category_name AS "Birim Fiyatı En Yüksek Kategori"
FROM categories c
WHERE EXISTS (
	SELECT category_id
	FROM products p
	WHERE p.category_id = c.category_id
	ORDER BY unit_price DESC)
LIMIT 1;

SELECT category_name AS "Birim Fiyatı En Yüksek Kategori"
FROM categories
WHERE category_id = (
    SELECT category_id
    FROM products
    ORDER BY unit_price DESC
LIMIT 1);

SELECT c.category_name AS "Birim Fiyatı En Yüksek Kategori"
FROM categories c
WHERE EXISTS (
    SELECT 1
    FROM products p
    WHERE p.category_id = c.category_id
    GROUP BY p.category_id
    HAVING MAX(unit_price) = MAX(p.unit_price))
LIMIT 1;

--120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)
SELECT *
FROM products p
WHERE EXISTS (
	SELECT *
	FROM categories c
	WHERE p.category_id = c.category_id
	AND c.category_name LIKE '%on%'
);

--121. Konbu adlı üründen kaç adet satılmıştır.
SELECT p.product_name, SUM(od.quantity) AS "Toplam Satılan Adet"
FROM products p
INNER JOIN order_details od ON p.product_id = od.product_id
WHERE p.product_name LIKE '%Konbu%'
GROUP BY p.product_name;

--122. Japonyadan kaç farklı ürün tedarik edilmektedir.
SELECT COUNT(DISTINCT p.product_id) AS "Farklı Ürün Sayısı"
FROM products p
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE s.country = 'Japan';

--123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
SELECT 
	MAX(freight) AS "En Yüksek Nakliye Ücreti",
	MIN(freight) AS "En Düşük Nakliye Ücreti",
	AVG(freight) AS "Ortalama Nakliye Ücreti"
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 1997;

--124. Faks numarası olan tüm müşterileri listeleyiniz.
SELECT *
FROM customers
WHERE fax IS NOT NULL;

--125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
SELECT *
FROM orders
WHERE shipped_date BETWEEN '1996-07-16' AND '1996-07-30';