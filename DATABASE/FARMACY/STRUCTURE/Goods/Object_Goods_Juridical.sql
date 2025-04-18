-- DROP TABLE IF EXISTS Object_Goods_Juridical;
/*
CREATE TABLE Object_Goods_Juridical (
  Id                  Serial,    -- Id
  GoodsMainId         integer,   -- Связь товаров с главным товаром
  JuridicalId         integer,   -- Связь товаров с поставщиком

  ObjectCode          Integer,   -- Код товара
  Name                TVarChar,  -- Название товара
  isErased            Boolean Not Null Default False,   -- Признак удален

  Code                TVarChar,  -- Строковый код (поставщика)   (zc_ObjectString_Goods_Code)
  MakerName           TVarChar,  -- Производитель                (zc_ObjectString_Goods_Maker)
  MinimumLot          TFloat,    -- Минимальная партия           (zc_ObjectFloat_Goods_MinimumLot)
  PromoBonus          TFloat,    -- Бонус по акции               (zc_ObjectFloat_Goods_PromoBonus)
  PromoBonusName      TVarChar,  -- Наименование бонусных упаковок по акции (zc_ObjectString_Goods_PromoBonusName)

  ConditionsKeepId    integer,   -- Условия хранения             (zc_ObjectLink_Goods_ConditionsKeep)
  AreaID              integer,   -- Регион                       (zc_ObjectLink_Goods_Area)
  DiscountExternalID  integer,   -- Товар для проекта (дисконтные карты) (zc_ObjectLink_Goods_DiscountExternal)

  isUpload            Boolean Not Null Default False,   -- Выгружается в отчете для поставщика          (zc_ObjectBoolean_Goods_IsUpload)
  isUploadBadm        Boolean Not Null Default False,   -- Выгружать в отчете для поставщика БАДМ       (zc_ObjectBoolean_Goods_UploadBadm)
  isUploadTeva        Boolean Not Null Default False,   -- Выгружать в отчете для поставщика Тева       (zc_ObjectBoolean_Goods_UploadTeva)
--    ALTER TABLE Object_Goods_Juridical  ADD COLUMN
  isUploadYuriFarm    Boolean Not Null Default False,   -- Выгружать в отчете для поставщика Юрия-Фарм  (zc_ObjectBoolean_Goods_UploadYuriFarm)
  isSpecCondition     Boolean Not Null Default False,   -- Товар под спецусловия                        (zc_ObjectBoolean_Goods_SpecCondition)
  isPromo             Boolean Not Null Default False,   -- Акция                                        (zc_ObjectBoolean_Goods_Promo)

  UKTZED              TVarChar,  -- Код товару згідно з УКТ ЗЕД             (zc_ObjectString_Goods_UKTZED)

  UserUpdateId        Integer,   -- Пользователь (корректировка)               (zc_ObjectLink_Protocol_Update)
  DateUpdate          TDateTime, -- Дата корректировки                         (Update zc_ObjectDate_Protocol_Update)

  UserUpdateMinimumLotId Integer,   -- Пользователь (корр. Мин. округл)        (zc_ObjectLink_Goods_UpdateMinimumLot)
  DateUpdateMinimumLot   TDateTime, -- Дата (корр. Мин. округл)                (zc_ObjectDate_Goods_UpdateMinimumLot) 

  UserUpdateisPromoId    Integer,   -- Пользователь (корр. Акция)              (zc_ObjectLink_Goods_UpdateMinimumLot)
  DateUpdateisPromo      TDateTime, -- Дата (корр. Акция)                      (zc_ObjectDate_Goods_UpdateisPromo)

  CONSTRAINT Object_Goods_Juridical_pkey PRIMARY KEY(Id)
);

CREATE INDEX IF NOT EXISTS idx_Object_Goods_Juridical_Id_GoodsMainId ON public.Object_Goods_Juridical
  USING btree (Id, GoodsMainId);

CREATE INDEX IF NOT EXISTS idx_Object_Goods_Juridical_GoodsMainId_JuridicalId ON public.Object_Goods_Juridical
  USING btree (GoodsMainId, JuridicalId);

CREATE INDEX IF NOT EXISTS idx_Object_Goods_Juridical_JuridicalId_GoodsMainId ON public.Object_Goods_Juridical
  USING btree (JuridicalId, GoodsMainId);

CREATE INDEX IF NOT EXISTS idx_Object_Goods_Juridical_JuridicalId ON public.Object_Goods_Juridical
  USING btree (JuridicalId);

ALTER TABLE Object_Goods_Juridical Add DiscountExternalID  integer

ALTER TABLE Object_Goods_Juridical Add PromoBonus          TFloat
ALTER TABLE Object_Goods_Juridical Add PromoBonusName      TVarChar

SELECT * FROM Object_Goods_Juridical
LIMIT 1000
SELECT Count(*) FROM Object_Goods_Juridical
*/

 WITH LinkGoods AS ( SELECT
                           Max(ObjectLink_LinkGoods_GoodsMain.ChildObjectId)  AS GoodsMainId
                         , ObjectLink_LinkGoods_Goods.ChildObjectId           AS GoodsId
                     FROM ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                          INNER JOIN ObjectBoolean AS ObjectBoolean_Goods_isMain
                                                   ON ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain()
                                                  AND ObjectBoolean_Goods_isMain.ObjectId = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
                          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                          ON ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                         AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                          -- связь с Юридические лица или Торговая сеть или ...
                          INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                               ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                              AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                          INNER JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = ObjectLink_Goods_Object.ChildObjectId
                                           AND Object_GoodsObject.DescId = zc_Object_Juridical()
                     WHERE ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                     GROUP BY ObjectLink_LinkGoods_Goods.ChildObjectId)

--INSERT INTO Object_Goods_Juridical
   SELECT
             Object_Goods.Id
           , LinkGoods.GoodsMainId                  AS GoodsMainId
           , ObjectLink_Goods_Object.ChildObjectId  AS Juridical

           , Object_Goods.ObjectCode                AS Code
           , Object_Goods.ValueData                 AS Name
           , Object_Goods.isErased

           , ObjectString_Goods_Code.ValueData      AS CodeStr
           , ObjectString_Goods_Maker.ValueData     AS MakerName

           , ObjectFloat_Goods_MinimumLot.ValueData AS MinimumLot

           , ObjectLink_Goods_ConditionsKeep.ChildObjectId AS ConditionsKeep
           , ObjectLink_Goods_Area.ChildObjectId           AS Area

           , COALESCE(ObjectBoolean_Goods_IsUpload.ValueData, FALSE)         AS IsUpload
           , COALESCE(ObjectBoolean_Goods_IsUploadBadm.ValueData, FALSE)     AS isUploadBadm
           , COALESCE(ObjectBoolean_Goods_IsUploadTeva.ValueData, FALSE)     AS isUploadTeva
           , COALESCE(ObjectBoolean_Goods_IsUploadYuriFarm.ValueData, FALSE) AS isUploadYuriFarm
           , COALESCE(ObjectBoolean_Goods_SpecCondition.ValueData, FALSE)    AS IsSpecCondition
           , COALESCE(ObjectBoolean_Goods_Promo.ValueData, FALSE)            AS isPromo

           , ObjectString_Goods_UKTZED.ValueData          AS UKTZED

           , ObjectLink_Protocol_Update.ChildObjectId         AS UserUpdate
           , ObjectDate_Protocol_Update.ValueData             AS DateUpdate

    FROM Object AS Object_Goods

         -- получается GoodsMainId
         LEFT JOIN (SELECT
                           Max(ObjectLink_LinkGoods_GoodsMain.ChildObjectId)  AS GoodsMainId
                         , ObjectLink_LinkGoods_Goods.ChildObjectId           AS GoodsId
                     FROM ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                          INNER JOIN ObjectBoolean AS ObjectBoolean_Goods_isMain
                                                   ON ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain()
                                                  AND ObjectBoolean_Goods_isMain.ObjectId = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
                          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                          ON ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                         AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                          -- связь с Юридические лица или Торговая сеть или ...
                          INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                               ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                              AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                          INNER JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = ObjectLink_Goods_Object.ChildObjectId
                                           AND Object_GoodsObject.DescId = zc_Object_Juridical()
                     WHERE ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                     GROUP BY ObjectLink_LinkGoods_Goods.ChildObjectId  ) AS LinkGoods ON LinkGoods.GoodsId = Object_Goods.Id

         -- связь с Юридические лица или Торговая сеть или ...
         LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                              ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
         LEFT JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = ObjectLink_Goods_Object.ChildObjectId
         LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId

         LEFT JOIN ObjectString AS ObjectString_Goods_Code
                                ON ObjectString_Goods_Code.ObjectId = Object_Goods.Id
                               AND ObjectString_Goods_Code.DescId = zc_ObjectString_Goods_Code()

         LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                ON ObjectString_Goods_Maker.ObjectId = Object_Goods.Id
                               AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()


         LEFT JOIN ObjectFloat AS ObjectFloat_Goods_MinimumLot
                               ON ObjectFloat_Goods_MinimumLot.ObjectId = Object_Goods.Id
                              AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep
                               ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                               ON ObjectLink_Goods_Area.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()


          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsUpload
                                  ON ObjectBoolean_Goods_IsUpload.ObjectId = Object_Goods.Id
                                 AND ObjectBoolean_Goods_IsUpload.DescId = zc_ObjectBoolean_Goods_IsUpload()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsUploadBadm
                                  ON ObjectBoolean_Goods_IsUploadBadm.ObjectId = Object_Goods.Id
                                 AND ObjectBoolean_Goods_IsUploadBadm.DescId = zc_ObjectBoolean_Goods_UploadBadm()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsUploadTeva
                                  ON ObjectBoolean_Goods_IsUploadTeva.ObjectId = Object_Goods.Id
                                 AND ObjectBoolean_Goods_IsUploadTeva.DescId = zc_ObjectBoolean_Goods_UploadTeva()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsUploadYuriFarm
                                  ON ObjectBoolean_Goods_IsUploadYuriFarm.ObjectId = Object_Goods.Id
                                 AND ObjectBoolean_Goods_IsUploadYuriFarm.DescId = zc_ObjectBoolean_Goods_UploadYuriFarm()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SpecCondition
                                  ON ObjectBoolean_Goods_SpecCondition.ObjectId = Object_Goods.Id
                                 AND ObjectBoolean_Goods_SpecCondition.DescId = zc_ObjectBoolean_Goods_SpecCondition()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Promo
                                  ON ObjectBoolean_Goods_Promo.ObjectId = Object_Goods.Id
                                 AND ObjectBoolean_Goods_Promo.DescId = zc_ObjectBoolean_Goods_Promo()

          LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                 ON ObjectString_Goods_UKTZED.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()

          LEFT JOIN ObjectLink AS ObjectLink_Protocol_Update
                               ON ObjectLink_Protocol_Update.ObjectId = Object_Goods.Id
                              AND ObjectLink_Protocol_Update.DescId = zc_ObjectLink_Protocol_Update()

          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                               ON ObjectDate_Protocol_Update.ObjectId = Object_Goods.Id
                              AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()


    WHERE Object_Goods.DescId = zc_Object_Goods()
      AND Object_GoodsObject.DescId = zc_Object_Juridical()
--      AND Object_Goods.Id = 74750
--      AND Object_Goods.Id in (1024992, 6030742)
--    LIMIT 1000
   ;