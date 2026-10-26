-- Qimmah: trails seed data (13 trails) - Stage 3 database design
-- Run inside the db container so Arabic text is kept:
--   docker compose cp backend/seed/trails.sql db:/tmp/trails.sql
--   docker compose exec db sh -c "mysql -uroot -p<password> --default-character-set=utf8mb4 qimmah < /tmp/trails.sql"
SET NAMES utf8mb4;

DELETE FROM trails;

INSERT INTO trails
  (id, name, description, region, difficulty, distance, estimatedDuration, images, safetyTips)
VALUES
  (1, 'مسار الغاط التاريخي', 'يقع مسار الغاط التاريخي في الغاط بمنطقة الرياض. مسار سهل بطول 2.83 كم، ويبلغ مجموع الصعود فيه نحو 93 م، ويستغرق قطعه قرابة ساعة ونصف.', 'الغاط', 'easy', 2.83, 'ساعة ونصف', '["https://climbing.sa/wp-content/uploads/2026/09/IMG_0436-1024x768.jpg"]', '• احرص على ارتداء أحذية مناسبة للمشي الجبلي.
• احمل كمية كافية من الماء.
• تجنب المسارات خلال سوء الأحوال الجوية.
• اتبع اللوحات الإرشادية ولا تترك النفايات خلفك.
• احترم البيئة والنباتات ولا تقطف أو تعبث بالحياة الفطرية.
• استخدم وسائل الحماية من الشمس (قبعة، واقي شمسي).'),
  (2, 'مسار حوطة سدير', 'يقع مسار حوطة سدير في حوطة سدير بمنطقة الرياض. مسار سهل بطول 5.55 كم، ويبلغ مجموع الصعود فيه نحو 125 م، ويستغرق قطعه قرابة ساعتين.', 'حوطة سدير', 'easy', 5.55, 'ساعتان', '["https://climbing.sa/wp-content/uploads/2026/09/IMG_0485-1024x768.jpg"]', '• احرص على ارتداء أحذية مناسبة للمشي الجبلي.
• احمل كمية كافية من الماء.
• تجنب المسارات خلال سوء الأحوال الجوية.
• اتبع اللوحات الإرشادية ولا تترك النفايات خلفك.
• احترم البيئة والنباتات ولا تقطف أو تعبث بالحياة الفطرية.
• استخدم وسائل الحماية من الشمس (قبعة، واقي شمسي).'),
  (3, 'مسار جبل ثهلان', 'يقع مسار جبل ثهلان في الدوادمي بمنطقة الرياض. مسار متوسط الصعوبة بطول 5.47 كم، ويبلغ مجموع الصعود فيه نحو 566 م، ويستغرق قطعه قرابة 3 ساعات.', 'الدوادمي', 'moderate', 5.47, '3 ساعات', '["https://climbing.sa/wp-content/uploads/2026/09/IMG_0683-1024x768.jpg"]', '• احرص على ارتداء أحذية مناسبة للمشي الجبلي.
• احمل كمية كافية من الماء.
• تجنب المسارات خلال سوء الأحوال الجوية.
• اتبع اللوحات الإرشادية ولا تترك النفايات خلفك.
• احترم البيئة والنباتات ولا تقطف أو تعبث بالحياة الفطرية.
• استخدم وسائل الحماية من الشمس (قبعة، واقي شمسي).'),
  (4, 'مسارات الغاط التاريخية – مسار الحوطه', 'يقع مسار الحوطة، أحد مسارات الغاط التاريخية، في الغاط بمنطقة الرياض. مسار متوسط الصعوبة بطول 7.46 كم، ويبلغ مجموع الصعود فيه نحو 91 م، ويستغرق قطعه قرابة ساعتين ونصف.', 'الغاط', 'moderate', 7.46, 'ساعتان ونصف', '["https://climbing.sa/wp-content/uploads/2026/09/IMG_0586-1024x768.jpg"]', '• احرص على ارتداء أحذية مناسبة للمشي الجبلي.
• احمل كمية كافية من الماء.
• تجنب المسارات خلال سوء الأحوال الجوية.
• اتبع اللوحات الإرشادية ولا تترك النفايات خلفك.
• احترم البيئة والنباتات ولا تقطف أو تعبث بالحياة الفطرية.
• استخدم وسائل الحماية من الشمس (قبعة، واقي شمسي).'),
  (5, 'مسار مصيقرة', 'يقع مسار مصيقرة في القويعية بمنطقة الرياض. مسار سهل بطول 8.33 كم، ويبلغ مجموع الصعود فيه نحو 144 م، ويستغرق قطعه قرابة 4 ساعات.', 'القويعية', 'easy', 8.33, '4 ساعات', '["https://climbing.sa/wp-content/uploads/2026/09/IMG_0293-1024x768.jpg"]', '• احرص على ارتداء أحذية مناسبة للمشي الجبلي.
• احمل كمية كافية من الماء.
• تجنب المسارات خلال سوء الأحوال الجوية.
• اتبع اللوحات الإرشادية ولا تترك النفايات خلفك.
• احترم البيئة والنباتات ولا تقطف أو تعبث بالحياة الفطرية.
• استخدم وسائل الحماية من الشمس (قبعة، واقي شمسي).'),
  (6, 'مسار مزعل جبل الشقراء', 'يقع مسار مزعل جبل الشقراء في القويعية بمنطقة الرياض. مسار سهل بطول 5.45 كم، ويبلغ مجموع الصعود فيه نحو 141 م، ويستغرق قطعه قرابة 3 ساعات.', 'القويعية', 'easy', 5.45, '3 ساعات', '["https://climbing.sa/wp-content/uploads/2026/09/IMG_0325-1024x768.jpg"]', '• احرص على ارتداء أحذية مناسبة للمشي الجبلي.
• احمل كمية كافية من الماء.
• تجنب المسارات خلال سوء الأحوال الجوية.
• اتبع اللوحات الإرشادية ولا تترك النفايات خلفك.
• احترم البيئة والنباتات ولا تقطف أو تعبث بالحياة الفطرية.
• استخدم وسائل الحماية من الشمس (قبعة، واقي شمسي).'),
  (7, 'مسار زبنه', 'يقع مسار زبنه في الدوادمي بمنطقة الرياض. مسار متوسط الصعوبة بطول 8 كم، ويبلغ مجموع الصعود فيه نحو 288 م، ويستغرق قطعه قرابة 3 ساعات.', 'الدوادمي', 'moderate', 8.0, '3 ساعات', '["https://climbing.sa/wp-content/uploads/2026/09/IMG_0750-1024x768.jpg"]', '• احرص على ارتداء أحذية مناسبة للمشي الجبلي.
• احمل كمية كافية من الماء.
• تجنب المسارات خلال سوء الأحوال الجوية.
• اتبع اللوحات الإرشادية ولا تترك النفايات خلفك.
• احترم البيئة والنباتات ولا تقطف أو تعبث بالحياة الفطرية.
• استخدم وسائل الحماية من الشمس (قبعة، واقي شمسي).'),
  (8, 'مسار القويعية', 'يقع مسار القويعية في القويعية بمنطقة الرياض. مسار سهل بطول 6.13 كم، ويبلغ مجموع الصعود فيه نحو 228 م، ويستغرق قطعه قرابة 3 ساعات.', 'القويعية', 'easy', 6.13, '3 ساعات', '["https://climbing.sa/wp-content/uploads/2026/09/IMG_0045-1024x768.jpg"]', '• احرص على ارتداء أحذية مناسبة للمشي الجبلي.
• احمل كمية كافية من الماء.
• تجنب المسارات خلال سوء الأحوال الجوية.
• اتبع اللوحات الإرشادية ولا تترك النفايات خلفك.
• احترم البيئة والنباتات ولا تقطف أو تعبث بالحياة الفطرية.
• استخدم وسائل الحماية من الشمس (قبعة، واقي شمسي).'),
  (9, 'مسار قارح – الماردية', 'يقع مسار قارح – الماردية في منطقة حائل. مسار صعب بطول 7.59 كم، ويبلغ مجموع الصعود فيه نحو 661 م، ويستغرق قطعه قرابة 6 ساعات.', 'حائل', 'hard', 7.59, '6 ساعات', '["https://climbing.sa/wp-content/uploads/2026/09/IMG_0537-1024x768.jpg"]', '• احرص على ارتداء أحذية مناسبة للمشي الجبلي.
• احمل كمية كافية من الماء.
• تجنب المسارات خلال سوء الأحوال الجوية.
• اتبع اللوحات الإرشادية ولا تترك النفايات خلفك.
• احترم البيئة والنباتات ولا تقطف أو تعبث بالحياة الفطرية.
• استخدم وسائل الحماية من الشمس (قبعة، واقي شمسي).'),
  (10, 'مسار كرا الاثري', 'يقع مسار كرا الاثري في الطائف بمنطقة مكة المكرمة. مسار متوسط الصعوبة بطول 5.84 كم، ويبلغ مجموع الصعود فيه نحو 515 م، ويستغرق قطعه قرابة 4 ساعات.', 'الطائف', 'moderate', 5.84, '4 ساعات', '["https://climbing.sa/wp-content/uploads/2026/09/IMG_2368-1024x768.jpg"]', '• احرص على ارتداء أحذية مناسبة للمشي الجبلي.
• احمل كمية كافية من الماء.
• تجنب المسارات خلال سوء الأحوال الجوية.
• اتبع اللوحات الإرشادية ولا تترك النفايات خلفك.
• احترم البيئة والنباتات ولا تقطف أو تعبث بالحياة الفطرية.
• استخدم وسائل الحماية من الشمس (قبعة، واقي شمسي).'),
  (11, 'مسار موقدة حاتم', 'يقع مسار موقدة حاتم في منطقة حائل. مسار متوسط الصعوبة بطول 4.34 كم، ويبلغ مجموع الصعود فيه نحو 182 م، ويستغرق قطعه قرابة ساعة ونصف.', 'حائل', 'moderate', 4.34, 'ساعة ونصف', '["https://climbing.sa/wp-content/uploads/2026/09/IMG_0503-1024x768.jpg"]', '• احرص على ارتداء أحذية مناسبة للمشي الجبلي.
• احمل كمية كافية من الماء.
• تجنب المسارات خلال سوء الأحوال الجوية.
• اتبع اللوحات الإرشادية ولا تترك النفايات خلفك.
• احترم البيئة والنباتات ولا تقطف أو تعبث بالحياة الفطرية.
• استخدم وسائل الحماية من الشمس (قبعة، واقي شمسي).'),
  (12, 'مسار عقدة – لامة', 'يقع مسار عقدة – لامة في منطقة حائل. مسار متوسط الصعوبة بطول 11.8 كم، ويبلغ مجموع الصعود فيه نحو 279 م، ويستغرق قطعه قرابة 4 ساعات.', 'حائل', 'moderate', 11.8, '4 ساعات', '["https://climbing.sa/wp-content/uploads/2026/08/CDA83CFD-6F4D-4A84-A9D4-7C865625BECF-1024x768.jpg"]', '• احرص على ارتداء أحذية مناسبة للمشي الجبلي.
• احمل كمية كافية من الماء.
• تجنب المسارات خلال سوء الأحوال الجوية.
• اتبع اللوحات الإرشادية ولا تترك النفايات خلفك.
• احترم البيئة والنباتات ولا تقطف أو تعبث بالحياة الفطرية.
• استخدم وسائل الحماية من الشمس (قبعة، واقي شمسي).'),
  (13, 'مسار المخاضة', 'يقع مسار المخاضة في الطائف بمنطقة مكة المكرمة. مسار سهل بطول 5.11 كم، ويبلغ مجموع الصعود فيه نحو 94 م، ويستغرق قطعه قرابة ساعتين.', 'الطائف', 'easy', 5.11, 'ساعتان', '["https://climbing.sa/wp-content/uploads/2026/07/20260329_140214_large-scaled-e1784788149750-1024x1024.jpg"]', '• احرص على ارتداء أحذية مناسبة للمشي الجبلي.
• احمل كمية كافية من الماء.
• تجنب المسارات خلال سوء الأحوال الجوية.
• اتبع اللوحات الإرشادية ولا تترك النفايات خلفك.
• احترم البيئة والنباتات ولا تقطف أو تعبث بالحياة الفطرية.
• استخدم وسائل الحماية من الشمس (قبعة، واقي شمسي).');

ALTER TABLE trails AUTO_INCREMENT = 14;

-- Trail images on Cloudinary (first image in each list = cover image)

-- 1. Al Ghat Historical Trail
UPDATE trails
SET images = '["https://res.cloudinary.com/ptn3plua/image/upload/v1792485898/%D9%85%D8%B3%D8%A7%D8%B1_%D8%A7%D9%84%D8%BA%D8%A7%D8%B7_%D8%A7%D9%84%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%D9%8A_10.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792485902/%D9%85%D8%B3%D8%A7%D8%B1_%D8%A7%D9%84%D8%BA%D8%A7%D8%B7_%D8%A7%D9%84%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%D9%8A_8.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792485904/%D9%85%D8%B3%D8%A7%D8%B1_%D8%A7%D9%84%D8%BA%D8%A7%D8%B7_%D8%A7%D9%84%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%D9%8A_6.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792485908/%D9%85%D8%B3%D8%A7%D8%B1_%D8%A7%D9%84%D8%BA%D8%A7%D8%B7_%D8%A7%D9%84%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%D9%8A_5.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792485913/%D9%85%D8%B3%D8%A7%D8%B1_%D8%A7%D9%84%D8%BA%D8%A7%D8%B7_%D8%A7%D9%84%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%D9%8A_3.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792485926/%D9%85%D8%B3%D8%A7%D8%B1_%D8%A7%D9%84%D8%BA%D8%A7%D8%B7_%D8%A7%D9%84%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%D9%8A_9.jpg"]'
WHERE id = 1;

-- 2. Hautat Sudair Trail
UPDATE trails
SET images = '["https://res.cloudinary.com/ptn3plua/image/upload/v1792486869/Hautat_Sudair_Trail_1.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792486866/Hautat_Sudair_Trail_3.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792486863/Hautat_Sudair_Trail_4.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792486857/Hautat_Sudair_Trail_7.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792486853/Hautat_Sudair_Trail_8.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792486851/Hautat_Sudair_Trail_5.jpg"]'
WHERE id = 2;

-- 3. Mount Thahlan Trail
UPDATE trails
SET images = '["https://res.cloudinary.com/ptn3plua/image/upload/v1792487995/Mount_Thahlan_Trail_1.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792487989/Mount_Thahlan_Trail_3.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792487984/Mount_Thahlan_Trail_4.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792487979/Mount_Thahlan_Trail_5.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792487969/Mount_Thahlan_Trail_6.jpg"]'
WHERE id = 3;

-- 4. Al Ghat Trail - Al Huttah Trail
UPDATE trails
SET images = '["https://res.cloudinary.com/ptn3plua/image/upload/v1792491415/Al_Ghat_Trail_Al_Huttah_Trail_1.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792491420/Al_Ghat_Trail_Al_Huttah_Trail_2.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792491426/Al_Ghat_Trail_Al_Huttah_Trail_3.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792491437/Al_Ghat_Trail_Al_Huttah_Trail_4.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792491443/Al_Ghat_Trail_Al_Huttah_Trail_6.jpg"]'
WHERE id = 4;

-- 5. Musaigrah Trail
UPDATE trails
SET images = '["https://res.cloudinary.com/ptn3plua/image/upload/v1792502041/Musaigrah_Trail_1.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792502034/Musaigrah_Trail_2.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792502028/Musaigrah_Trail_3.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792502022/Musaigrah_Trail_4.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792502017/Musaigrah_Trail_5.jpg"]'
WHERE id = 5;

-- 6. Mizil Jabal Al-Shaqraa Trail
UPDATE trails
SET images = '["https://res.cloudinary.com/ptn3plua/image/upload/v1792508701/Mizil_Jabal_Al-Shaqraa_Trail_1.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792502557/Mizil_Jabal_Al-Shaqraa_Trail_3.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792502549/Mizil_Jabal_Al-Shaqraa_Trail_4.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792502540/Mizil_Jabal_Al-Shaqraa_Trail_5.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792502531/Mizil_Jabal_Al-Shaqraa_Trail_6.jpg"]'
WHERE id = 6;

-- 7. Zabnah Trail
UPDATE trails
SET images = '["https://res.cloudinary.com/ptn3plua/image/upload/v1792502891/Zabnah_Trail_1.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792502892/Zabnah_Trail_2.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792502892/Zabnah_Trail_3.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792502892/Zabnah_Trail_4.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792502890/Zabnah_Trail_5.jpg"]'
WHERE id = 7;

-- 8. Al-Quwayiyah Trail
UPDATE trails
SET images = '["https://res.cloudinary.com/ptn3plua/image/upload/v1792503734/Al-Quwayiyah_Trail_1.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792503734/Al-Quwayiyah_Trail_3.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792503735/Al-Quwayiyah_Trail_4.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792503732/Al-Quwayiyah_Trail_5.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792503732/Al-Quwayiyah_Trail_6.jpg"]'
WHERE id = 8;

-- 9. Qarh - Al Mardiyah Trail
UPDATE trails
SET images = '["https://res.cloudinary.com/ptn3plua/image/upload/v1792517880/Al-Mardiyah-Qarh_Trail_1.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792517882/Al-Mardiyah-Qarh_Trail_2.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792517882/Al-Mardiyah-Qarh_Trail_3.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792517881/Al-Mardiyah-Qarh_Trail_4.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792517879/Al-Mardiyah-Qarh_Trail_5.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792517878/Al-Mardiyah-Qarh_Trail_6.jpg"]'
WHERE id = 9;

-- 10. Kara Heritage Trail
UPDATE trails
SET images = '["https://res.cloudinary.com/ptn3plua/image/upload/v1792504241/Kara_Heritage_Trail_1.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792504240/Kara_Heritage_Trail_2.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792504238/Kara_Heritage_Trail_3.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792504236/Kara_Heritage_Trail_4.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792504236/Kara_Heritage_Trail_5.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792504234/Kara_Heritage_Trail_6.jpg"]'
WHERE id = 10;

-- 11. Hatem Fire Lighthouse Trail
UPDATE trails
SET images = '["https://res.cloudinary.com/ptn3plua/image/upload/v1792504942/Hatem_Firen_Lighthouse_Trail_1.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792504940/Hatem_Firen_Lighthouse_Trail_2.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792504940/Hatem_Firen_Lighthouse_Trail_3.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792504938/Hatem_Firen_Lighthouse_Trail_4.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792504682/Hatem_Firen_Lighthouse_Trail_5.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792504675/Hatem_Firen_Lighthouse_Trail_6.jpg"]'
WHERE id = 11;

-- 12. Egdah - Lamah Trail
UPDATE trails
SET images = '["https://res.cloudinary.com/ptn3plua/image/upload/v1792518506/Egdah_Lamah_Trail_1.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792518504/Egdah_Lamah_Trail_2.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792518503/Egdah_Lamah_Trail_3.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792518501/Egdah_Lamah_Trail_4.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792518501/Egdah_Lamah_Trail_5.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792518500/Egdah_Lamah_Trail_6.jpg"]'
WHERE id = 12;

-- 13. Al Makhadah Trail
UPDATE trails
SET images = '["https://res.cloudinary.com/ptn3plua/image/upload/v1792505350/Al_Makhadah_Trail_1.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792505347/Al_Makhadah_Trail_2.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792505345/Al_Makhadah_Trail_3.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792505342/Al_Makhadah_Trail_4.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792505340/Al_Makhadah_Trail_5.jpg", "https://res.cloudinary.com/ptn3plua/image/upload/v1792505338/Al_Makhadah_Trail_6.jpg"]'
WHERE id = 13;
