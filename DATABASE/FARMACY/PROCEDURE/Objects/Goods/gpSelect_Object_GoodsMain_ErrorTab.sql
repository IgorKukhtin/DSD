-- Function: gpSelect_Object_GoodsMain_ErrorTab()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsMain_ErrorTab(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsMain_ErrorTab(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, CodeStr TVarChar, Name TVarChar, isErased Boolean,
               LinkId Integer, GoodsMainId Integer,
               GoodsGroupId Integer, GoodsGroupName TVarChar,
               MeasureId Integer, MeasureName TVarChar,
               NDSKindId Integer, NDSKindName TVarChar,
               NDS TFloat, MinimumLot TFloat,
               isClose Boolean, isTOP Boolean, isPromo Boolean, isFirst Boolean, isSecond Boolean, isPublished Boolean,
               isUpload Boolean, isSpecCondition Boolean,
               PercentMarkup TFloat, Price TFloat,
               ReferCode TFloat, ReferPrice TFloat,
               ObjectDescName TVarChar, ObjectName TVarChar,
               MakerName TVarChar, MakerLinkName TVarChar,
               ConditionsKeepName TVarChar,
               AreaName TVarChar,
               CodeMarion Integer, CodeMarionStr TVarChar, NameMarion TVarChar, OrdMarion Integer,
               CodeBar Integer, NameBar TVarChar, OrdBar Integer
              ) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);
   

   RETURN QUERY
    WITH tmpObject AS (  WITH GoodsRetail AS (
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

   WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain()
                   )
                   
              
      , tmpTab AS (SELECT Object_Goods_Main.*
                        , Object_ConditionsKeep.ValueData AS ConditionsKeepName
                   FROM Object_Goods_Main
                        LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = Object_Goods_Main.ConditionsKeepId
                   )     
                   
   -- Результат
   SELECT
             ObjectLink_Main.ChildObjectId      AS Id
           , Object_Goods.ObjectCode            AS Code
           , ObjectString_Goods_Code.ValueData  AS CodeStr
           , Object_Goods.ValueData             AS Name
           , Object_Goods.isErased

           , ObjectLink_Main.ObjectId      AS LinkId
           , Object_Goods.Id               AS GoodsMainId
           , Object_GoodsGroup.Id          AS GoodsGroupId
           , Object_GoodsGroup.ValueData   AS GoodsGroupName
           , Object_Measure.Id             AS MeasureId
           , Object_Measure.ValueData      AS MeasureName

           , Object_NDSKind.Id                 AS NDSKindId
           , Object_NDSKind.ValueData          AS NDSKindName
           , ObjectFloat_NDSKind_NDS.ValueData AS NDS

           , ObjectFloat_Goods_MinimumLot.ValueData AS MinimumLot

           , ObjectBoolean_Goods_Close.ValueData    AS isClose
           , ObjectBoolean_Goods_TOP.ValueData      AS isTOP
           , ObjectBoolean_Goods_IsPromo.ValueData  AS IsPromo
           , ObjectBoolean_First.ValueData          AS isFirst
           , ObjectBoolean_Second.ValueData         AS isSecond
           , ObjectBoolean_Published.ValueData      AS isPublished
           , ObjectBoolean_Goods_IsUpload.ValueData       AS IsUpload
           , ObjectBoolean_Goods_SpecCondition.ValueData  AS IsSpecCondition

           , ObjectFloat_Goods_PercentMarkup.ValueData AS PercentMarkup
           , ObjectFloat_Goods_Price.ValueData         AS Price
           , ObjectFloat_Goods_ReferCode.ValueData     AS ReferCode
           , ObjectFloat_Goods_ReferPrice.ValueData    AS ReferPrice

           , ObjectDesc_GoodsObject.itemname    AS  ObjectDescName
           , Object_GoodsObject.ValueData       AS  ObjectName

           , ObjectString_Goods_Maker.ValueData AS MakerName
           , Object_Maker.ValueData             AS MakerLinkName
           , Object_ConditionsKeep.ValueData    AS ConditionsKeepName
           , Object_Area.ValueData              AS AreaName

           , tmpMarion.GoodsCode       AS CodeMarion
           , tmpMarion.GoodsCodeStr    AS CodeMarionStr
           , tmpMarion.GoodsName       AS NameMarion
           , tmpMarion.Ord  :: Integer AS OrdMarion

           , tmpBarCode.GoodsCode      AS CodeBar
           , tmpBarCode.GoodsName      AS NameBar
           , tmpBarCode.Ord :: Integer AS OrdBar

    FROM tmpTab
         LEFT JOIN tmpObject ON tmpTab.Id                = tmpObject.Id               
                            AND tmpTab.GoodsCode         = tmpObject.GoodsCode        
                            AND tmpTab.GoodsName         = tmpObject.GoodsName        
                            AND tmpTab.MorionCode        = tmpObject.MorionCode       
                            AND tmpTab.isErased          = tmpObject.isErased         
                            AND tmpTab.isClose           = tmpObject.isClose          
                            AND tmpTab.isNotUploadSites  = tmpObject.isNotUploadSites 
                            AND tmpTab.isDoesNotShare    = tmpObject.isDoesNotShare   
                            AND tmpTab.isAllowDivision   = tmpObject.isAllowDivision  
                            AND tmpTab.isNotTransferTime = tmpObject.isNotTransferTime
                            AND tmpTab.isNotMarion       = tmpObject.isNotMarion      
                            AND tmpTab.isNOT             = tmpObject.isNOT            
                            AND tmpTab.GoodsGroupId      = tmpObject.GoodsGroupId     
                            AND tmpTab.MeasureId         = tmpObject.MeasureId        
                            AND tmpTab.NDSKindId         = tmpObject.NDSKindId        
                            AND tmpTab.Exchange          = tmpObject.Exchange         
                            AND tmpTab.ConditionsKeep    = tmpObject.ConditionsKeep   
                            AND tmpTab.GoodsGroupPromoID = tmpObject.GoodsGroupPromoID
                            AND tmpTab.ReferCode         = tmpObject.ReferCode        
                            AND tmpTab.ReferPrice        = tmpObject.ReferPrice       
                            AND tmpTab.CountPrice        = tmpObject.CountPrice       
                            AND tmpTab.LastPrice         = tmpObject.LastPrice        
                            AND tmpTab.LastPriceOld      = tmpObject.LastPriceOld     
                            AND tmpTab.MakerName         = tmpObject.MakerName        
                            AND tmpTab.NameUkr           = tmpObject.NameUkr          
                            AND tmpTab.CodeUKTZED        = tmpObject.CodeUKTZED       
                            AND tmpTab.Analog            = tmpObject.Analog           
                            AND tmpTab.Published         = tmpObject.Published        
                            AND tmpTab.SiteKey           = tmpObject.SiteKey          
                            AND tmpTab.Foto              = tmpObject.Foto             
                            AND tmpTab.Thumb             = tmpObject.Thumb            
                            AND tmpTab.Appointment       = tmpObject.Appointment      

    WHERE tmpObject.Id IS NULL
           
           
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.03.16                                        *
 25.02.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsAll_Common (zfCalc_UserAdmin()) AS tmp WHERE COALESCE (tmp.Code, 0) IN (SELECT COALESCE (tmp2.Code, 0) FROM gpSelect_Object_GoodsAll_Common (zfCalc_UserAdmin()) AS tmp2 GROUP BY COALESCE (tmp2.Code, 0) HAVING COUNT(*) > 1)
-- SELECT * FROM gpSelect_Object_GoodsAll_Common (zfCalc_UserAdmin())

/*

 WITH tmpObject AS (  WITH GoodsRetail AS (
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

   WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain()
                   )
                   
              
      , tmpTab AS (SELECT Object_Goods_Main.*
                        , Object_ConditionsKeep.ValueData AS ConditionsKeepName
                   FROM Object_Goods_Main
                        LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = Object_Goods_Main.ConditionsKeepId
                   )     
                   
   -- Результат
   SELECT
tmpTab.Id   ,tmpObject.Id               
   , tmpTab.ObjectCode        , tmpObject.GoodsCode        
, tmpTab.Name         , tmpObject.GoodsName        
                            , tmpTab.MorionCode        , tmpObject.MorionCode       
                            , tmpTab.isErased          , tmpObject.isErased         
                            , tmpTab.isClose           , tmpObject.isClose          
                            , tmpTab.isNotUploadSites  , tmpObject.isNotUploadSites 
                            , tmpTab.isDoesNotShare    , tmpObject.isDoesNotShare   
                            , tmpTab.isAllowDivision   , tmpObject.isAllowDivision  
                            , tmpTab.isNotTransferTime , tmpObject.isNotTransferTime
                            , tmpTab.isNotMarion       , tmpObject.isNotMarion      
                            , tmpTab.isNOT             , tmpObject.isNOT            
                            , tmpTab.GoodsGroupId      , tmpObject.GoodsGroupId     
                            , tmpTab.MeasureId         , tmpObject.MeasureId        
                            , tmpTab.NDSKindId         , tmpObject.NDSKindId        
                            , tmpTab.ExchangeId          , tmpObject.Exchange         
                            , tmpTab.ConditionsKeepId    , tmpObject.ConditionsKeep
                            , tmpTab.GoodsGroupPromoID , tmpObject.GoodsGroupPromoID
                            , tmpTab.ReferCode         , tmpObject.ReferCode        
                            , tmpTab.ReferPrice        , tmpObject.ReferPrice       
                            , tmpTab.CountPrice        , tmpObject.CountPrice       
                            , tmpTab.LastPrice         , tmpObject.LastPrice        
                            , tmpTab.LastPriceOld      , tmpObject.LastPriceOld     
                            , tmpTab.MakerName         , tmpObject.MakerName        
                            , tmpTab.NameUkr           , tmpObject.NameUkr          
                            , tmpTab.CodeUKTZED        , tmpObject.CodeUKTZED       
                            , tmpTab.Analog            , tmpObject.Analog           
                            , tmpTab.isPublished         , tmpObject.Published        
                            , tmpTab.SiteKey           , tmpObject.SiteKey          
                            , tmpTab.Foto              , tmpObject.Foto             
                            , tmpTab.Thumb             , tmpObject.Thumb            
                            , tmpTab.AppointmentId      , tmpObject.Appointment   


    FROM tmpTab
         LEFT JOIN tmpObject ON tmpTab.Id                = tmpObject.Id               
    WHERE     tmpTab.ObjectCode        <> tmpObject.GoodsCode        
                            OR tmpTab.Name         <> tmpObject.GoodsName     --"Оксигель гель 10% 20г";"Оксигель гель 10% 20г"    
                            OR COALESCE (tmpTab.MorionCode,0)        <>    COALESCE (tmpObject.MorionCode ,0)        -- 64
                            OR COALESCE (tmpTab.isErased, FALSE)          <>    COALESCE (tmpObject.isErased , FALSE)         
                            OR COALESCE (tmpTab.isClose, FALSE)            <>    COALESCE (tmpObject.isClose , FALSE)          
                            OR COALESCE (tmpTab.isNotUploadSites, FALSE)   <>    COALESCE (tmpObject.isNotUploadSites , FALSE) 
                            OR COALESCE (tmpTab.isDoesNotShare, FALSE)     <>    COALESCE (tmpObject.isDoesNotShare , FALSE)   
                            OR COALESCE (tmpTab.isAllowDivision, FALSE)    <>    COALESCE (tmpObject.isAllowDivision , FALSE)  
                            OR COALESCE (tmpTab.isNotTransferTime, FALSE)  <>    COALESCE (tmpObject.isNotTransferTime, FALSE) 
                            OR COALESCE (tmpTab.isNotMarion, FALSE)        <>    COALESCE (tmpObject.isNotMarion , FALSE)      
                            OR COALESCE (tmpTab.isNOT, FALSE)              <>    COALESCE (tmpObject.isNOT , FALSE)            
                            OR COALESCE (tmpTab.GoodsGroupId,0)      <>    COALESCE (tmpObject.GoodsGroupId,0)     
                            OR COALESCE (tmpTab.MeasureId,0)         <>    COALESCE (tmpObject.MeasureId,0)        
                            OR COALESCE (tmpTab.NDSKindId,0)         <>  COALESCE (tmpObject.NDSKindId,0)        
                            OR COALESCE (tmpTab.ExchangeId,0)          <>  COALESCE (tmpObject.Exchange,0)         
                            OR COALESCE (tmpTab.ConditionsKeepId,0)    <>  COALESCE (tmpObject.ConditionsKeep,0)
                            OR COALESCE (tmpTab.GoodsGroupPromoID,0) <>    COALESCE (tmpObject.GoodsGroupPromoID,0)
                            OR COALESCE (tmpTab.ReferCode,0)         <>    COALESCE (tmpObject.ReferCode,0)        
                            OR COALESCE (tmpTab.ReferPrice,0)        <>    COALESCE (tmpObject.ReferPrice,0)       
                            OR COALESCE (tmpTab.CountPrice,0)        <>    COALESCE (tmpObject.CountPrice,0)       
                            OR COALESCE (tmpTab.LastPrice ,Null)        <>    COALESCE (tmpObject.LastPrice ,Null)       
                            OR COALESCE (tmpTab.LastPriceOld,Null)      <>    COALESCE (tmpObject.LastPriceOld,Null)     
                            OR COALESCE (tmpTab.MakerName,'')         <>    COALESCE (tmpObject.MakerName ,'')       
                            OR COALESCE (tmpTab.NameUkr,'')           <>    COALESCE (tmpObject.NameUkr,'')          
                            OR COALESCE (tmpTab.CodeUKTZED,'')        <>    COALESCE (tmpObject.CodeUKTZED,'')       
                            OR COALESCE (tmpTab.Analog,'')            <>    COALESCE (tmpObject.Analog,'')           
                            OR COALESCE (tmpTab.isPublished, FALSE)        <>    COALESCE (tmpObject.Published, FALSE)         
                            OR COALESCE (tmpTab.SiteKey,0)           <>    COALESCE (tmpObject.SiteKey,0)          
                            OR COALESCE (tmpTab.Foto,'')              <>    COALESCE (tmpObject.Foto,'')             
                            OR COALESCE (tmpTab.Thumb,'')             <>    COALESCE (tmpObject.Thumb ,'')           
                            OR COALESCE (tmpTab.AppointmentId,0)  <>    COALESCE (tmpObject.Appointment,0)   

   -- WHERE tmpObject.Id IS NULL

*/
