-- DROP TABLE IF EXISTS Object_Goods_Main;

CREATE TABLE Object_Goods_Main (
  Id                  Serial,    -- Id товара
  ObjectCode          Integer,   -- Код товара
  Name                TVarChar,  -- Название товара
  MorionCode          Integer,   -- Код мориона

  isErased            Boolean Not Null Default False,   -- Признак удален
  isClose             Boolean Not Null Default False,   -- Закрыт для заказа                          (zc_ObjectBoolean_Goods_Close)
  isNotUploadSites    Boolean Not Null Default False,   -- Не выгружать для сайтов                    (zc_ObjectBoolean_Goods_isNotUploadSites)
  isDoesNotShare      Boolean Not Null Default False,   -- Не делить медикамент на кассах (фармацевты)(zc_ObjectBoolean_Goods_DoesNotShare)
  isAllowDivision     Boolean Not Null Default False,   -- Разрешить деление товара на кассе          (zc_ObjectBoolean_Goods_AllowDivision)
  isNotTransferTime   Boolean Not Null Default False,   -- Не переводить в сроки                      (zc_ObjectBoolean_Goods_NotTransferTime)
  isNotMarion         Boolean Not Null Default False,   -- Не устанавливать связь с кодом Марион      (zc_ObjectBoolean_Goods_NotMarion)
  isNOT               Boolean Not Null Default False,   -- НОТ-неперемещаемый остаток                 (zc_ObjectBoolean_Goods_NOT)
  isResolution_224    Boolean Not Null Default False,   -- Постанова 224                              (zc_ObjectBoolean_Goods_Resolution_224)
  isInvisibleSUN      Boolean Not Null Default False,   -- Невидимка для ограничений по СУН           (zc_ObjectBoolean_Goods_InvisibleSUN)
  isSupplementSUN1    Boolean Not Null Default False,   -- Дополнение СУН1                            (zc_ObjectBoolean_Goods_SupplementSUN1)
  isSupplementMarkSUN1 Boolean Not Null Default False,   -- Дополнение СУН1 маркетинг                 (zc_ObjectBoolean_Goods_SupplementMarkSUN1)
  isSupplementSUN2    Boolean Not Null Default False,   -- Дополнение СУН2                            (zc_ObjectBoolean_Goods_SupplementSUN2)
  isExceptionUKTZED   Boolean Not Null Default False,   -- Исключение для запрета к фискальной продаже по УКТВЭД (zc_ObjectBoolean_Goods_ExceptionUKTZED)
  isPresent           Boolean Not Null Default False,   -- Подарок                                    (zc_ObjectBoolean_Goods_Present)
  isOnlySP            Boolean Not Null Default False,   -- Только для СП "Доступные лики"             (zc_ObjectBoolean_Goods_OnlySP)
  isMultiplicityError Boolean Not Null Default False,   -- Погрешность для кратности при продажи      (zc_ObjectBoolean_Goods_MultiplicityError)
  isRecipe            Boolean Not Null Default False,   -- Рецептура/Не рецептура                     (zc_ObjectBoolean_Goods_Recipe)
  isSupplementSmudge  Boolean Not Null Default False,   -- Дополнение СУН1 размазать товар            (zc_ObjectBoolean_Goods_SupplementSUN1Smudge)
  isExpDateExcSite    Boolean Not Null Default False,   -- Исключение по сроку годности (для сайта)   (zc_ObjectBoolean_Goods_ExpDateExcSite)
  isHideOnTheSite     Boolean Not Null Default False,   -- Скрывать на сайте нет в наличии и в поставках (zc_ObjectBoolean_Goods_HideOnTheSite)
  isAllowedPlatesSUN  Boolean Not Null Default False,   -- Разрешено перемещение пластинками в СУН    (zc_ObjectBoolean_Goods_AllowedPlatesSUN)
  isColdSUN           Boolean Not Null Default False,   -- Холод для СУН                              (zc_ObjectBoolean_Goods_ColdSUN)
  isLeftTheMarket     Boolean Not Null Default False,   -- Ушел с рынка                               (zc_ObjectBoolean_Goods_LeftTheMarket)
  isStealthBonuses    Boolean Not Null Default False,   -- Стелс для бонусов мобильного приложения    (zc_ObjectBoolean_Goods_StealthBonuses)

  GoodsGroupId        integer,   -- Связь товаров с группой товаров           (zc_ObjectLink_Goods_GoodsGroup)
  MeasureId           integer,   -- Связь товаров с единицей измерения        (zc_ObjectLink_Goods_Measure)
  NDSKindId           integer,   -- Связь товаров с Видом НДС                 (ObjectLink_Goods_NDSKind)
  ExchangeId          integer,   -- Связь товаров с одиницей виміру           (zc_ObjectLink_Goods_Exchange)
  ConditionsKeepId    integer,   -- Условия хранения                          (zc_ObjectLink_Goods_ConditionsKeep)
  FormDispensingId    integer,   -- Форма отпуска                             (zc_ObjectLink_Goods_FormDispensing)

  GoodsWhoCanId       integer,   -- Кому можно                                (zc_ObjectLink_Goods_GoodsWhoCan)
  GoodsMethodApplId   integer,   -- Способ применения                         (zc_ObjectLink_Goods_GoodsMethodAppl)
  GoodsSignOriginId   integer,   -- Признак происхождения                     (zc_ObjectLink_Goods_GoodsSignOrigin)

  UnitSupplementSUN1OutId integer,   -- Подразделения для отправки по дополнению СУН1 (zc_ObjectLink_Goods_UnitSupplementSUN1Out)
  UnitSupplementSUN2OutId integer,   -- Подразделения для отправки по дополнению СУН1 (zc_ObjectLink_Goods_UnitSupplementSUN2Out)
  UnitSupplementSUN1InId integer,    -- Аптека получатель вне работы дополнения СУН1 (zc_ObjectLink_Goods_UnitSupplementSUN1In)

  ReferCode           integer,   -- Код референтной цены                       (zc_ObjectFloat_Goods_ReferCode)
  ReferPrice          TFloat,    -- Референтная цена                           (zc_ObjectFloat_Goods_ReferPrice)

  CountPrice          TFloat,    -- Кол-во прайсов                            (zc_ObjectFloat_Goods_CountPrice)

  LastPrice           TDateTime, -- Дата загрузки прайса                      (zc_ObjectDate_Goods_LastPrice)
  LastPriceOld        TDateTime, -- Пред Послед. дата наличия на рынке        (zc_ObjectDate_Goods_LastPriceOld)

  MakerName           TVarChar,  --  Производитель                            (zc_ObjectString_Goods_Maker)
  MakerNameUkr        TVarChar,  --  Производитель украинское название        (zc_ObjectString_Goods_MakerUkr)

  NameUkr             TVarChar,  -- Название украинское                       (zc_ObjectString_Goods_NameUkr)
  CodeUKTZED          TVarChar,  -- Код УКТЗЭД                                (zc_ObjectString_Goods_CodeUKTZED)
  Analog              TVarChar,  -- Перечень аналогов товара                  (zc_ObjectString_Goods_Analog)
  AnalogATC           TVarChar,  -- Перечень аналогов товара ATC              (zc_ObjectString_Goods_AnalogATC)
  ActiveSubstance     TVarChar,  -- Действующее вещество                      (zc_ObjectString_Goods_ActiveSubstance)

  Dosage              TVarChar,  -- Дозировка                                 (zc_ObjectString_Goods_Dosage)
  Volume              TVarChar,  -- Объем                                     (zc_ObjectString_Goods_Volume)
  GoodsWhoCanList     TVarChar,  -- Кому можно                                (zc_ObjectString_Goods_GoodsWhoCan)

  IdSP                TVarChar,  -- ID лікарського засобу в СП                (zc_ObjectString_Goods_IdSP)

  Multiplicity        TFloat,    -- Кратность при придаже                     (zc_ObjectFloat_Goods_Multiplicity)

  NumberPlates        integer,   -- Кол-во пластин в упаковке                 (zc_ObjectFloat_Goods_NumberPlates)
  QtyPackage          integer,   -- Кол-во в упаковке                         (zc_ObjectFloat_Goods_QtyPackage)

  SupplementMin       integer,   -- Размазать в дополнении СУН не менее чем   (zc_ObjectFloat_Goods_SupplementMin)
  SupplementMinPP     integer,   -- Размазать в дополнении СУН для аптечных пунктов не менее чем   (zc_ObjectFloat_Goods_SupplementMinPP)

   -- Для сайта
  isPublished         Boolean Not Null Default False,   -- Опубликован на сайте                       (zc_ObjectBoolean_Goods_Published)
  SiteKey             integer,   -- Ключ товара на сайте                       (zc_ObjectFloat_Goods_Site)

  isPublishedSite     Boolean,   -- Опубликован на сайте загружено с сайта

  NameUkrSite         TVarChar,  -- Название украинское с сайта
  isNameUkrSite       Boolean Not Null Default False,   -- Изменить на сайте. Название украинское с сайта
  MakerNameSite       TVarChar,  -- Производитель с сайта
  isMakerNameSite     Boolean Not Null Default False,   -- Изменить на сайте. Производитель с сайта
  MakerNameUkrSite    TVarChar,  -- Производитель украинское название с сайта
  isMakerNameUkrSite  Boolean Not Null Default False,   -- Изменить на сайте. Производитель украинское название с сайта

  Foto                TVarChar,  -- Путь к фото                                (zc_ObjectString_Goods_Foto)
  Thumb               TVarChar,  -- Путь к превью фото                         (zc_ObjectString_Goods_Thumb)
  AppointmentId       integer,   -- Назначение товара                          (zc_ObjectLink_Goods_Appointment)

  PromoBonus          TFloat,    -- Бонус для отчета "Остатки по подразделению с бонусом"
  PriceSip            TFloat,    -- Цена сип для отчета "Остатки по подразделению с бонусом"

  DateUpdateClose     TDateTime, -- Дата изменения isClose
  DateUpdateSite      TDateTime, -- Дата изменения для отправки на сайт
  DateDownloadsSite   TDateTime, -- Дата загрузки данных с сайта  
  DateLeftTheMarket   TDateTime, -- Дата Ушел с рынка  
  DateAddToOrder      TDateTime, -- Дата добавления в заказ после возвращения кода

  CONSTRAINT Object_Goods_Main_pkey PRIMARY KEY(Id)
);



/*
03.05.20 add isNOT_Sun_v4               Boolean Not Null Default False,   -- НОТ-неперемещаемый остаток для СУН-v2 (zc_ObjectBoolean_Goods_NOT_Sun_v2)

ALTER TABLE Object_Goods_Main ADD QtyPackage          integer

*/

/*
17.12.19 add isNOT_Sun_v2               Boolean Not Null Default False,   -- НОТ-неперемещаемый остаток для СУН-v2 (zc_ObjectBoolean_Goods_NOT_Sun_v2)

ALTER TABLE Object_Goods_Main ADD isNOT_Sun_v2 Boolean Not Null Default False

ALTER TABLE Object_Goods_Main ADD UnitSupplementSUN2OutId integer

ALTER TABLE Object_Goods_Main ADD  Multiplicity        TFloat

ALTER TABLE Object_Goods_Main ADD  MakerNameUkr        TVarChar

ALTER TABLE Object_Goods_Main ADD    NameUkrSite         TVarChar
ALTER TABLE Object_Goods_Main ADD    MakerNameSite       TVarChar
ALTER TABLE Object_Goods_Main ADD    MakerNameUkrSite    TVarChar

ALTER TABLE Object_Goods_Main ADD  Dosage              TVarChar
ALTER TABLE Object_Goods_Main ADD  Volume              TVarChar
ALTER TABLE Object_Goods_Main ADD  GoodsWhoCanId       integer
ALTER TABLE Object_Goods_Main ADD  GoodsMethodApplId   integer
ALTER TABLE Object_Goods_Main ADD  IdSP                TVarChar

ALTER TABLE Object_Goods_Main ADD   isStealthBonuses    Boolean Not Null Default False

ALTER TABLE Object_Goods_Main ADD   PriceSip            TFloat


*/


CREATE INDEX IF NOT EXISTS idx_Object_Goods_Main_Id_ObjectCode ON public.Object_Goods_Main
  USING btree (Id, ObjectCode);

  ALTER TABLE Object_Goods_Main ADD


SELECT * FROM Object_Goods_Main
*/

      WITH GoodsRetail AS (
      SELECT ObjectLink_Main.ChildObjectId                            AS GoodsMainId

           , NULLIF(ObjectString_Goods_NameUkr.ValueData, '')         AS NameUkr
           , NULLIF(ObjectString_Goods_CodeUKTZED.ValueData, '')      AS CodeUKTZED

           , ObjectBoolean_Goods_Close.ValueData                      AS Close
           , ObjectBoolean_Goods_isNotUploadSites.ValueData           AS isNotUploadSites
           , ObjectBoolean_Goods_DoesNotShare.ValueData               AS DoesNotShare
           , ObjectBoolean_Goods_AllowDivision.ValueData              AS AllowDivision
           , ObjectBoolean_Goods_NotMarion.ValueData                  AS NotMarion
           , ObjectBoolean_Goods_NOT.ValueData                        AS NOT

           , ObjectBoolean_Goods_Published.ValueData                  AS Published
           , ObjectFloat_Goods_Site.ValueData::Integer                AS Site
           , ObjectString_Goods_Foto.ValueData                        AS Foto
           , ObjectString_Goods_Thumb.ValueData                       AS Thumb
           , ObjectLink_Goods_Appointment.ChildObjectId               AS Appointment
           , ObjectLink_Goods_ConditionsKeep.ChildObjectId            AS ConditionsKeep

           , ObjectLink_Goods_GoodsGroup.ChildObjectId                AS GoodsGroupId
           , ObjectLink_Goods_GoodsGroupPromo.ChildObjectId           AS GoodsGroupPromoID
           , ObjectLink_Goods_Exchange.ChildObjectId                  AS Exchange

           , ObjectFloat_Goods_ReferCode.ValueData::Integer           AS ReferCode
           , ObjectFloat_Goods_ReferPrice.ValueData                   AS ReferPrice

           , NULLIF(ObjectString_Goods_Maker.ValueData, '')           AS MakerName


      FROM Object AS Object_Goods

           -- получается GoodsMainId
           LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                                                    AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
           LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                   AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

           LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
           LEFT JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = ObjectLink_Goods_Object.ChildObjectId
           LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId

           LEFT JOIN ObjectString AS ObjectString_Goods_NameUkr
                                  ON ObjectString_Goods_NameUkr.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_NameUkr.DescId = zc_ObjectString_Goods_NameUkr()

           LEFT JOIN ObjectString AS ObjectString_Goods_CodeUKTZED
                                  ON ObjectString_Goods_CodeUKTZED.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_CodeUKTZED.DescId = zc_ObjectString_Goods_CodeUKTZED()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_isNotUploadSites
                                   ON ObjectBoolean_Goods_isNotUploadSites.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_Goods_isNotUploadSites.DescId = zc_ObjectBoolean_Goods_isNotUploadSites()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_DoesNotShare
                                   ON ObjectBoolean_Goods_DoesNotShare.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_Goods_DoesNotShare.DescId = zc_ObjectBoolean_Goods_DoesNotShare()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_AllowDivision
                                   ON ObjectBoolean_Goods_AllowDivision.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_Goods_AllowDivision.DescId = zc_ObjectBoolean_Goods_AllowDivision()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Published
                                   ON ObjectBoolean_Goods_Published.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_Goods_Published.DescId = zc_ObjectBoolean_Goods_Published()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_NotMarion
                                   ON ObjectBoolean_Goods_NotMarion.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_Goods_NotMarion.DescId = zc_ObjectBoolean_Goods_NotMarion()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_NOT
                                   ON ObjectBoolean_Goods_NOT.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_Goods_NOT.DescId = zc_ObjectBoolean_Goods_NOT()

           LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Site
                                 ON ObjectFloat_Goods_Site.ObjectId = Object_Goods.Id
                                AND ObjectFloat_Goods_Site.DescId = zc_ObjectFloat_Goods_Site()

           LEFT JOIN ObjectString AS ObjectString_Goods_Foto
                                  ON ObjectString_Goods_Foto.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_Foto.DescId = zc_ObjectString_Goods_Foto()

           LEFT JOIN ObjectString AS ObjectString_Goods_Thumb
                                  ON ObjectString_Goods_Thumb.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_Thumb.DescId = zc_ObjectString_Goods_Thumb()

           LEFT JOIN ObjectLink AS ObjectLink_Goods_Appointment
                                ON ObjectLink_Goods_Appointment.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Appointment.DescId = zc_ObjectLink_Goods_Appointment()

           LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep
                                ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupPromo
                                ON ObjectLink_Goods_GoodsGroupPromo.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroupPromo.DescId = zc_ObjectLink_Goods_GoodsGroupPromo()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Exchange
                                 ON ObjectLink_Goods_Exchange.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Exchange.DescId = zc_ObjectLink_Goods_Exchange()


           LEFT JOIN ObjectFloat AS ObjectFloat_Goods_ReferCode
                                 ON ObjectFloat_Goods_ReferCode.ObjectId = Object_Goods.Id
                                AND ObjectFloat_Goods_ReferCode.DescId = zc_ObjectFloat_Goods_ReferCode()
           LEFT JOIN ObjectFloat AS ObjectFloat_Goods_ReferPrice
                                 ON ObjectFloat_Goods_ReferPrice.ObjectId = Object_Goods.Id
                                AND ObjectFloat_Goods_ReferPrice.DescId = zc_ObjectFloat_Goods_ReferPrice()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                   ON ObjectBoolean_Goods_Close.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()

           LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                  ON ObjectString_Goods_Maker.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()

      WHERE Object_Goods.DescId = zc_Object_Goods()
        AND Object_GoodsObject.DescId = zc_Object_Retail()
        AND Object_GoodsObject.ID = 4
     ),
     DoesNotShare AS (
      SELECT DISTINCT
             ObjectLink_Main.ChildObjectId                            AS GoodsMainId

           , True                                                     AS DoesNotShare


      FROM ObjectBoolean AS ObjectBoolean_Goods_DoesNotShare

           -- получается GoodsMainId
           LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = ObjectBoolean_Goods_DoesNotShare.ObjectId
                                                    AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
           LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                   AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

      WHERE ObjectBoolean_Goods_DoesNotShare.DescId = zc_ObjectBoolean_Goods_DoesNotShare()
        AND ObjectBoolean_Goods_DoesNotShare.ValueData = True
     ),
     NotTransferTime AS (
      SELECT DISTINCT
             ObjectLink_Main.ChildObjectId                            AS GoodsMainId

           , True                                                     AS NotTransferTime


      FROM ObjectBoolean AS ObjectBoolean_Goods_NotTransferTime

           -- получается GoodsMainId
           LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = ObjectBoolean_Goods_NotTransferTime.ObjectId
                                                    AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
           LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                   AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

      WHERE ObjectBoolean_Goods_NotTransferTime.DescId = zc_ObjectBoolean_Goods_NotTransferTime()
        AND ObjectBoolean_Goods_NotTransferTime.ValueData = True
     ),
     MorionCode AS (SELECT ObjectLink_Main_Morion.ChildObjectId          AS GoodsMainId
                         , MAX (Object_Goods_Morion.ObjectCode)::Integer AS MorionCode
                    FROM ObjectLink AS ObjectLink_Main_Morion
                         JOIN ObjectLink AS ObjectLink_Child_Morion
                                         ON ObjectLink_Child_Morion.ObjectId = ObjectLink_Main_Morion.ObjectId
                                        AND ObjectLink_Child_Morion.DescId = zc_ObjectLink_LinkGoods_Goods()
                         JOIN ObjectLink AS ObjectLink_Goods_Object_Morion
                                         ON ObjectLink_Goods_Object_Morion.ObjectId = ObjectLink_Child_Morion.ChildObjectId
                                        AND ObjectLink_Goods_Object_Morion.DescId = zc_ObjectLink_Goods_Object()
                                        AND ObjectLink_Goods_Object_Morion.ChildObjectId = zc_Enum_GlobalConst_Marion()
                         LEFT JOIN Object AS Object_Goods_Morion ON Object_Goods_Morion.Id = ObjectLink_Goods_Object_Morion.ObjectId
                    WHERE ObjectLink_Main_Morion.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                      AND ObjectLink_Main_Morion.ChildObjectId > 0
                    GROUP BY ObjectLink_Main_Morion.ChildObjectId)

--insert into Object_Goods_Main
 SELECT
             ObjectBoolean_Goods_isMain.ObjectId              AS Id
           , Object_Goods.ObjectCode                          AS GoodsCode
           , Object_Goods.ValueData                           AS GoodsName
           , MorionCode.MorionCode                            AS MorionCode
           , Object_Goods.isErased                            AS isErased

           , COALESCE(GoodsRetail.Close, FALSE)               AS isClose
           , COALESCE(GoodsRetail.isNotUploadSites, FALSE)    AS isNotUploadSites
           , COALESCE(DoesNotShare.DoesNotShare, FALSE)       AS isDoesNotShare
           , COALESCE(GoodsRetail.AllowDivision, FALSE)       AS isAllowDivision
           , COALESCE(NotTransferTime.NotTransferTime, FALSE) AS isNotTransferTime
           , COALESCE(GoodsRetail.NotMarion, FALSE)           AS isNotMarion
           , COALESCE(GoodsRetail.NOT, FALSE)                 AS isNOT

           , GoodsRetail.GoodsGroupId                         AS GoodsGroupId
           , ObjectLink_Goods_Measure.ChildObjectId           AS MeasureId
           , ObjectLink_Goods_NDSKind.ChildObjectId           AS NDSKindId
           , GoodsRetail.Exchange                             AS Exchange
           , GoodsRetail.ConditionsKeep                       AS ConditionsKeep


           , GoodsRetail.GoodsGroupPromoID                    AS GoodsGroupPromoID

           , GoodsRetail.ReferCode                            AS ReferCode
           , GoodsRetail.ReferPrice                           AS ReferPrice

           , ObjectFloat_Goods_CountPrice.ValueData           AS CountPrice

           , ObjectDate_Goods_LastPrice.ValueData             AS LastPrice
           , ObjectDate_Goods_LastPriceOld.ValueData          AS LastPriceOld

           , GoodsRetail.MakerName                            AS MakerName

           , GoodsRetail.NameUkr                              AS NameUkr
           , GoodsRetail.CodeUKTZED                           AS CodeUKTZED
           , ObjectString_Goods_Analog.ValueData              AS Analog

           , COALESCE(GoodsRetail.Published, FALSE)           AS Published
           , GoodsRetail.Site                                 AS SiteKey
           , GoodsRetail.Foto                                 AS Foto
           , GoodsRetail.Thumb                                AS Thumb
           , GoodsRetail.Appointment                          AS Appointment

       FROM ObjectBoolean AS ObjectBoolean_Goods_isMain

            LEFT JOIN Object AS Object_Goods
                             ON Object_Goods.Id = ObjectBoolean_Goods_isMain.ObjectId

            LEFT JOIN MorionCode ON MorionCode.GoodsMainId = Object_Goods.Id

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()


            LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                 ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()

            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_CountPrice
                                  ON ObjectFloat_Goods_CountPrice.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Goods_CountPrice.DescId = zc_ObjectFloat_Goods_CountPrice()

            LEFT JOIN ObjectDate AS ObjectDate_Goods_LastPrice
                                 ON ObjectDate_Goods_LastPrice.ObjectId = Object_Goods.Id
                                AND ObjectDate_Goods_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()

            LEFT JOIN ObjectDate AS ObjectDate_Goods_LastPriceOld
                                 ON ObjectDate_Goods_LastPriceOld.ObjectId = Object_Goods.Id
                                AND ObjectDate_Goods_LastPriceOld.DescId = zc_ObjectDate_Goods_LastPriceOld()

            LEFT JOIN ObjectString AS ObjectString_Goods_Analog
                                   ON ObjectString_Goods_Analog.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_Analog.DescId = zc_ObjectString_Goods_Analog()

            LEFT JOIN GoodsRetail ON GoodsRetail.GoodsMainId = ObjectBoolean_Goods_isMain.ObjectId
            LEFT JOIN DoesNotShare ON DoesNotShare.GoodsMainId = ObjectBoolean_Goods_isMain.ObjectId
            LEFT JOIN NotTransferTime ON NotTransferTime.GoodsMainId = ObjectBoolean_Goods_isMain.ObjectId

   WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain();