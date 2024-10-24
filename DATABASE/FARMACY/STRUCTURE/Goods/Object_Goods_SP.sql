-- DROP TABLE IF EXISTS Object_Goods_SP;
/*
CREATE TABLE Object_Goods_SP (
  id                  Serial,    -- ID основного товара

  isSP                Boolean,   -- участвует в Соц. проекте                 (zc_ObjectBoolean_Goods_SP)

  IntenalSPID         integer,   -- Міжнародна непатентована назва (2)(СП)   (zc_ObjectLink_Goods_IntenalSP)
  BrandSPID           integer,   -- Торгова назва лікарського засобу (3)(СП) (zc_ObjectLink_Goods_BrandSP)
  KindOutSPID         integer,   -- Форма випуску (4)(СП)                    (zc_ObjectLink_Goods_KindOutSP)

--  GroupSP             TFloat,    -- Групи відшкоду-вання – І або ІІ                                   (zc_ObjectFloat_Goods_GroupSP)
  PriceSP             TFloat,    -- Розмір відшкодування за упаковку лікарського засобу (15)(СП)      (zc_ObjectFloat_Goods_PriceSP)
  CountSP             Integer,   -- Кількість одиниць лікарського засобу у споживчій упаковці (6)(СП) (zc_ObjectFloat_Goods_CountSP)
  PriceOptSP          TFloat,    -- Оптово-відпускна ціна за упаковку (11)(СП)                        (zc_ObjectFloat_Goods_PriceOptSP)
  PriceRetSP          TFloat,    -- Роздрібна ціна за упаковку (12)(СП)                               (zc_ObjectFloat_Goods_PriceRetSP)
  DailyNormSP         TFloat,    -- Добова доза лікарського засобу, рекомендована ВООЗ (13)(СП)       (zc_ObjectFloat_Goods_DailyNormSP)
  PaymentSP           TFloat,    -- Сума доплати за упаковку (16)(СП)                                 (zc_ObjectFloat_Goods_PaymentSP)
  ColSP               Integer,   -- № п.п.(1)(СП)                                                     (zc_ObjectFloat_Goods_ColSP)
  DailyCompensationSP TFloat,    -- Розмір відшкодування добової дози лікарського засобу (14)(СП)     (zc_ObjectFloat_Goods_DailyCompensationSP)
  ReestrDateSP        TVarChar,  -- Дата закінчення строку дії реєстраційного посвідчення на лікарський засіб(10)(СП) (zc_ObjectString_Goods_ReestrDateSP)
  MakerSP             TVarChar,  -- Найменування виробника, країна(8)(СП)                             (zc_ObjectString_Goods_MakerSP)
  ReestrSP            TVarChar,  -- № реєстраційного посвідчення на лікарський засіб(Соц. проект)(9)  (zc_ObjectString_Goods_ReestrSP)

  Pack                TVarChar,  -- Сила дії/ дозування (5)(СП)               (zc_ObjectString_Goods_Pack)
  CodeATX             TVarChar,  -- Код АТХ (7)(СП)                           (zc_ObjectString_Goods_CodeATX)

  PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS idx_Object_Goods_SP_Id ON public.Object_Goods_SP
  USING btree (Id);

SELECT * FROM Object_Goods_SP
*/

--insert into Object_Goods_SP
 SELECT
             ObjectBoolean_Goods_isMain.ObjectId              AS Id

           , ObjectBoolean_Goods_SP.ValueData                 AS isSP

           , ObjectLink_Goods_IntenalSP.ChildObjectId         AS IntenalSP
           , ObjectLink_Goods_BrandSP.ChildObjectId           AS BrandSP
           , ObjectLink_Goods_KindOutSP.ChildObjectId         AS KindOutSP

--           , ObjectFloat_Goods_GroupSP.ValueData              AS GroupSP
           , ObjectFloat_Goods_PriceSP.ValueData              AS PriceSP
           , ObjectFloat_Goods_CountSP.ValueData::Integer     AS CountSP
           , ObjectFloat_Goods_PriceOptSP.ValueData           AS PriceOptSP
           , ObjectFloat_Goods_PriceRetSP.ValueData           AS PriceRetSP
           , ObjectFloat_Goods_DailyNormSP.ValueData          AS DailyNormSP
           , ObjectFloat_Goods_PaymentSP.ValueData            AS PaymentSP
           , ObjectFloat_Goods_ColSP.ValueData::Integer       AS ColSP
           , ObjectFloat_Goods_DailyCompensationSP.ValueData  AS DailyCompensationSP
           , ObjectString_Goods_ReestrSP.ValueData            AS ReestrSP

           , ObjectString_Goods_ReestrDateSP.ValueData        AS ReestrDateSP
           , ObjectString_Goods_MakerSP.ValueData             AS MakerSP

           , ObjectString_Goods_Pack.ValueData                AS Pack
           , ObjectString_Goods_CodeATX.ValueData             AS CodeATX

       FROM ObjectBoolean AS ObjectBoolean_Goods_isMain

            LEFT JOIN Object AS Object_Goods
                             ON Object_Goods.Id = ObjectBoolean_Goods_isMain.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_IntenalSP
                                 ON ObjectLink_Goods_IntenalSP.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_IntenalSP.DescId = zc_ObjectLink_Goods_IntenalSP()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_BrandSP
                                 ON ObjectLink_Goods_BrandSP.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_BrandSP.DescId = zc_ObjectLink_Goods_BrandSP()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_KindOutSP
                                 ON ObjectLink_Goods_KindOutSP.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_KindOutSP.DescId = zc_ObjectLink_Goods_KindOutSP()

            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_GroupSP
                                  ON ObjectFloat_Goods_GroupSP.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Goods_GroupSP.DescId = zc_ObjectFloat_Goods_GroupSP()
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceSP
                                  ON ObjectFloat_Goods_PriceSP.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Goods_PriceSP.DescId = zc_ObjectFloat_Goods_PriceSP()
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_CountSP
                                  ON ObjectFloat_Goods_CountSP.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Goods_CountSP.DescId = zc_ObjectFloat_Goods_CountSP()
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceOptSP
                                  ON ObjectFloat_Goods_PriceOptSP.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Goods_PriceOptSP.DescId = zc_ObjectFloat_Goods_PriceOptSP()
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceRetSP
                                  ON ObjectFloat_Goods_PriceRetSP.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Goods_PriceRetSP.DescId = zc_ObjectFloat_Goods_PriceRetSP()
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_DailyNormSP
                                  ON ObjectFloat_Goods_DailyNormSP.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Goods_DailyNormSP.DescId = zc_ObjectFloat_Goods_DailyNormSP()
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PaymentSP
                                  ON ObjectFloat_Goods_PaymentSP.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Goods_PaymentSP.DescId = zc_ObjectFloat_Goods_PaymentSP()
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_ColSP
                                  ON ObjectFloat_Goods_ColSP.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Goods_ColSP.DescId = zc_ObjectFloat_Goods_ColSP()
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_DailyCompensationSP
                                  ON ObjectFloat_Goods_DailyCompensationSP.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Goods_DailyCompensationSP.DescId = zc_ObjectFloat_Goods_DailyCompensationSP()
            LEFT JOIN ObjectString AS ObjectString_Goods_ReestrDateSP
                                   ON ObjectString_Goods_ReestrDateSP.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_ReestrDateSP.DescId = zc_ObjectString_Goods_ReestrDateSP()
            LEFT JOIN ObjectString AS ObjectString_Goods_MakerSP
                                   ON ObjectString_Goods_MakerSP.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_MakerSP.DescId = zc_ObjectString_Goods_MakerSP()

            LEFT JOIN ObjectString AS ObjectString_Goods_ReestrSP
                                   ON ObjectString_Goods_ReestrSP.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_ReestrSP.DescId = zc_ObjectString_Goods_ReestrSP()

            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_CountPrice
                                  ON ObjectFloat_Goods_CountPrice.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Goods_CountPrice.DescId = zc_ObjectFloat_Goods_CountPrice()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SP
                                    ON ObjectBoolean_Goods_SP.ObjectId = Object_Goods.Id
                                   AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()

            LEFT JOIN ObjectString AS ObjectString_Goods_Pack
                                   ON ObjectString_Goods_Pack.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_Pack.DescId = zc_ObjectString_Goods_Pack()

            LEFT JOIN ObjectString AS ObjectString_Goods_CodeATX
                                   ON ObjectString_Goods_CodeATX.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_CodeATX.DescId = zc_ObjectString_Goods_CodeATX()

   WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain()
     AND (COALESCE (ObjectBoolean_Goods_SP.ValueData, False) = TRUE
      OR COALESCE (ObjectLink_Goods_IntenalSP.ChildObjectId, 0) <> 0) ;
