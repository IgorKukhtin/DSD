-- Function: gpSelect_Object_GoodsMain_ErrorTab()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsMain_ErrorTab(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsMain_ErrorTab(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);
   
   CREATE TEMP TABLE tmpData (Id Integer
                            , ObjectCode_tab        Integer  , ObjectCode        Integer  , Color_Code               Integer, isErr_Code              Boolean
                            , Name_tab              TVarChar , Name              TVarChar , Color_Name               Integer, isErr_Name              Boolean
                            , MorionCode_tab        Integer  , MorionCode        Integer  , Color_MorionCode         Integer, isErr_MorionCode        Boolean
                            , isErased_tab          Boolean  , isErased          Boolean  , Color_isErased           Integer, isErr_isErased          Boolean
                            , isClose_tab           Boolean  , isClose           Boolean  , Color_isClose            Integer, isErr_isClose           Boolean
                            , isNotUploadSites_tab  Boolean  , isNotUploadSites  Boolean  , Color_isNotUploadSites   Integer, isErr_isNotUploadSites  Boolean
                            , isDoesNotShare_tab    Boolean  , isDoesNotShare    Boolean  , Color_isDoesNotShare     Integer, isErr_isDoesNotShare    Boolean
                            , isAllowDivision_tab   Boolean  , isAllowDivision   Boolean  , Color_isAllowDivision    Integer, isErr_isAllowDivision   Boolean
                            , isNotTransferTime_tab Boolean  , isNotTransferTime Boolean  , Color_isNotTransferTime  Integer, isErr_isNotTransferTime Boolean
                            , isNotMarion_tab       Boolean  , isNotMarion       Boolean  , Color_isNotMarion        Integer, isErr_isNotMarion       Boolean
                            , isNOT_tab             Boolean  , isNOT             Boolean  , Color_isNOT              Integer, isErr_isNOT             Boolean
                            , GoodsGroupId_tab      integer  , GoodsGroupId      Integer  , Color_GoodsGroupId       Integer, isErr_GoodsGroupId      Boolean
                            , MeasureId_tab         integer  , MeasureId         Integer  , Color_MeasureId          Integer, isErr_MeasureId         Boolean
                            , NDSKindId_tab         integer  , NDSKindId         Integer  , Color_NDSKindId          Integer, isErr_NDSKindId         Boolean
                            , ExchangeId_tab        integer  , ExchangeId        Integer  , Color_Exchange           Integer, isErr_Exchange          Boolean
                            , ConditionsKeepId_tab  integer  , ConditionsKeepId  Integer  , Color_ConditionsKeepId   Integer, isErr_ConditionsKeepId  Boolean
                            , GoodsGroupPromoId_tab integer  , GoodsGroupPromoID Integer  , Color_GoodsGroupPromoID  Integer, isErr_GoodsGroupPromoID Boolean
                            , ReferCode_tab         integer  , ReferCode         Integer  , Color_ReferCode          Integer, isErr_ReferCode         Boolean
                            , ReferPrice_tab        TFloat   , ReferPrice        TFloat   , Color_ReferPrice         Integer, isErr_ReferPrice        Boolean
                            , CountPrice_tab        TFloat   , CountPrice        TFloat   , Color_CountPrice         Integer, isErr_CountPrice        Boolean
                            , LastPrice_tab         TDateTime, LastPrice         TDateTime, Color_LastPrice          Integer, isErr_LastPrice         Boolean
                            , LastPriceOld_tab      TDateTime, LastPriceOld      TDateTime, Color_LastPriceOld       Integer, isErr_LastPriceOld      Boolean
                            , MakerName_tab         TVarChar , MakerName         TVarChar , Color_MakerName          Integer, isErr_MakerName         Boolean
                            , NameUkr_tab           TVarChar , NameUkr           TVarChar , Color_NameUkr            Integer, isErr_NameUkr           Boolean
                            , CodeUKTZED_tab        TVarChar , CodeUKTZED        TVarChar , Color_CodeUKTZED         Integer, isErr_CodeUKTZED        Boolean
                            , Analog_tab            TVarChar , Analog            TVarChar , Color_Analog             Integer, isErr_Analog            Boolean
                            , isPublished_tab       Boolean  , isPublished       Boolean  , Color_isPublished        Integer, isErr_isPublished       Boolean
                            , SiteKey_tab           integer  , SiteKey           integer  , Color_SiteKey            Integer, isErr_SiteKey           Boolean
                            , Foto_tab              TVarChar , Foto              TVarChar , Color_Foto               Integer, isErr_Foto              Boolean
                            , Thumb_tab             TVarChar , Thumb             TVarChar , Color_Thumb              Integer, isErr_Thumb             Boolean
                            , AppointmentId_tab     integer  , AppointmentId     integer  , Color_AppointmentId      Integer, isErr_AppointmentId     Boolean
                            ) ON COMMIT DROP;

         INSERT INTO tmpData (Id
                            , ObjectCode_tab        , ObjectCode       , Color_Code               , isErr_Code             
                            , Name_tab              , Name             , Color_Name               , isErr_Name             
                            , MorionCode_tab        , MorionCode       , Color_MorionCode         , isErr_MorionCode       
                            , isErased_tab          , isErased         , Color_isErased           , isErr_isErased         
                            , isClose_tab           , isClose          , Color_isClose            , isErr_isClose          
                            , isNotUploadSites_tab  , isNotUploadSites , Color_isNotUploadSites   , isErr_isNotUploadSites 
                            , isDoesNotShare_tab    , isDoesNotShare   , Color_isDoesNotShare     , isErr_isDoesNotShare   
                            , isAllowDivision_tab   , isAllowDivision  , Color_isAllowDivision    , isErr_isAllowDivision  
                            , isNotTransferTime_tab , isNotTransferTime, Color_isNotTransferTime  , isErr_isNotTransferTime
                            , isNotMarion_tab       , isNotMarion      , Color_isNotMarion        , isErr_isNotMarion      
                            , isNOT_tab             , isNOT            , Color_isNOT              , isErr_isNOT            
                            , GoodsGroupId_tab      , GoodsGroupId     , Color_GoodsGroupId       , isErr_GoodsGroupId     
                            , MeasureId_tab         , MeasureId        , Color_MeasureId          , isErr_MeasureId        
                            , NDSKindId_tab         , NDSKindId        , Color_NDSKindId          , isErr_NDSKindId        
                            , ExchangeId_tab        , ExchangeId       , Color_Exchange           , isErr_Exchange         
                            , ConditionsKeepId_tab  , ConditionsKeepId , Color_ConditionsKeepId   , isErr_ConditionsKeepId 
                            , GoodsGroupPromoId_tab , GoodsGroupPromoID, Color_GoodsGroupPromoID  , isErr_GoodsGroupPromoID
                            , ReferCode_tab         , ReferCode        , Color_ReferCode          , isErr_ReferCode        
                            , ReferPrice_tab        , ReferPrice       , Color_ReferPrice         , isErr_ReferPrice       
                            , CountPrice_tab        , CountPrice       , Color_CountPrice         , isErr_CountPrice       
                            , LastPrice_tab         , LastPrice        , Color_LastPrice          , isErr_LastPrice        
                            , LastPriceOld_tab      , LastPriceOld     , Color_LastPriceOld       , isErr_LastPriceOld     
                            , MakerName_tab         , MakerName        , Color_MakerName          , isErr_MakerName        
                            , NameUkr_tab           , NameUkr          , Color_NameUkr            , isErr_NameUkr          
                            , CodeUKTZED_tab        , CodeUKTZED       , Color_CodeUKTZED         , isErr_CodeUKTZED       
                            , Analog_tab            , Analog           , Color_Analog             , isErr_Analog           
                            , isPublished_tab       , isPublished      , Color_isPublished        , isErr_isPublished      
                            , SiteKey_tab           , SiteKey          , Color_SiteKey            , isErr_SiteKey          
                            , Foto_tab              , Foto             , Color_Foto               , isErr_Foto             
                            , Thumb_tab             , Thumb            , Color_Thumb              , isErr_Thumb            
                            , AppointmentId_tab     , AppointmentId    , Color_AppointmentId      , isErr_AppointmentId    
                            )
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
  
   WITH tmpObject AS (  
                      WITH 
                          GoodsRetail AS (SELECT ObjectLink_Main.ChildObjectId                            AS GoodsMainId
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
                                                                      ON ObjectString_Goods_CodeUKTZED.ObjectId = ObjectLink_Goods_Object.ChildObjectId
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
                                         )
                        , DoesNotShare AS (SELECT DISTINCT
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
                                         )
                        , NotTransferTime AS (SELECT DISTINCT
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
                                             )
                        , MorionCode AS (SELECT ObjectLink_Main_Morion.ChildObjectId          AS GoodsMainId
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
                                         GROUP BY ObjectLink_Main_Morion.ChildObjectId
                                         )
                      SELECT
                              ObjectBoolean_Goods_isMain.ObjectId              AS Id
                            , Object_Goods.ObjectCode                          AS ObjectCode
                            , Object_Goods.ValueData                           AS Name
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
                            , GoodsRetail.Exchange                             AS ExchangeId
                            , GoodsRetail.ConditionsKeep                       AS ConditionsKeepId
                            , GoodsRetail.GoodsGroupPromoID                    AS GoodsGroupPromoId
                            , GoodsRetail.ReferCode                            AS ReferCode
                            , GoodsRetail.ReferPrice                           AS ReferPrice
                            , ObjectFloat_Goods_CountPrice.ValueData           AS CountPrice
                            , ObjectDate_Goods_LastPrice.ValueData             AS LastPrice
                            , ObjectDate_Goods_LastPriceOld.ValueData          AS LastPriceOld
                            , GoodsRetail.MakerName                            AS MakerName
                            , GoodsRetail.NameUkr                              AS NameUkr
                            , GoodsRetail.CodeUKTZED                           AS CodeUKTZED
                            , ObjectString_Goods_Analog.ValueData              AS Analog
                            , COALESCE(GoodsRetail.Published, FALSE)           AS isPublished
                            , GoodsRetail.Site                                 AS SiteKey
                            , GoodsRetail.Foto                                 AS Foto
                            , GoodsRetail.Thumb                                AS Thumb
                            , GoodsRetail.Appointment                          AS AppointmentId
                 
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

      -- сохраненные данные
      , tmpTab AS (SELECT Object_Goods_Main.*
                   FROM Object_Goods_Main
                   )     

     -- Результат
     SELECT tmpTab.Id 
          , tmpTab.ObjectCode        AS ObjectCode_tab        , tmpObject.ObjectCode       , CASE WHEN tmpTab.ObjectCode                           <> tmpObject.ObjectCode                          THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_Code             , CASE WHEN tmpTab.ObjectCode                           <> tmpObject.ObjectCode                          THEN TRUE ELSE FALSE ENd AS isErr_Code                                                                
          , tmpTab.Name              AS Name_tab              , tmpObject.Name             , CASE WHEN COALESCE (tmpTab.Name,'')                   <> COALESCE (tmpObject.Name, '')                 THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_Name             , CASE WHEN COALESCE (tmpTab.Name,'')                   <> COALESCE (tmpObject.Name, '')                 THEN TRUE ELSE FALSE ENd AS isErr_Name             
          , tmpTab.MorionCode        AS MorionCode_tab        , tmpObject.MorionCode       , CASE WHEN COALESCE (tmpTab.MorionCode,0)              <> COALESCE (tmpObject.MorionCode ,0)            THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_MorionCode       , CASE WHEN COALESCE (tmpTab.MorionCode,0)              <> COALESCE (tmpObject.MorionCode ,0)            THEN TRUE ELSE FALSE ENd AS isErr_MorionCode       --10
                                                                                                                                                                                                                                                                                                                                                                                                                                                             
          , tmpTab.isErased          AS isErased_tab          , tmpObject.isErased         , CASE WHEN COALESCE (tmpTab.isErased, FALSE)           <> COALESCE (tmpObject.isErased , FALSE)         THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_isErased         , CASE WHEN COALESCE (tmpTab.isErased, FALSE)           <> COALESCE (tmpObject.isErased , FALSE)         THEN TRUE ELSE FALSE ENd AS isErr_isErased         
          , tmpTab.isClose           AS isClose_tab           , tmpObject.isClose          , CASE WHEN COALESCE (tmpTab.isClose, FALSE)            <> COALESCE (tmpObject.isClose , FALSE)          THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_isClose          , CASE WHEN COALESCE (tmpTab.isClose, FALSE)            <> COALESCE (tmpObject.isClose , FALSE)          THEN TRUE ELSE FALSE ENd AS isErr_isClose          
          , tmpTab.isNotUploadSites  AS isNotUploadSites_tab  , tmpObject.isNotUploadSites , CASE WHEN COALESCE (tmpTab.isNotUploadSites, FALSE)   <> COALESCE (tmpObject.isNotUploadSites , FALSE) THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_isNotUploadSites , CASE WHEN COALESCE (tmpTab.isNotUploadSites, FALSE)   <> COALESCE (tmpObject.isNotUploadSites , FALSE) THEN TRUE ELSE FALSE ENd AS isErr_isNotUploadSites --19
                                                                                                                                                                                                                                                                                                                                                                                                                                                             
          , tmpTab.isDoesNotShare    AS isDoesNotShare_tab    , tmpObject.isDoesNotShare   , CASE WHEN COALESCE (tmpTab.isDoesNotShare, FALSE)     <> COALESCE (tmpObject.isDoesNotShare , FALSE)   THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_isDoesNotShare   , CASE WHEN COALESCE (tmpTab.isDoesNotShare, FALSE)     <> COALESCE (tmpObject.isDoesNotShare , FALSE)   THEN TRUE ELSE FALSE ENd AS isErr_isDoesNotShare   
          , tmpTab.isAllowDivision   AS isAllowDivision_tab   , tmpObject.isAllowDivision  , CASE WHEN COALESCE (tmpTab.isAllowDivision, FALSE)    <> COALESCE (tmpObject.isAllowDivision , FALSE)  THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_isAllowDivision  , CASE WHEN COALESCE (tmpTab.isAllowDivision, FALSE)    <> COALESCE (tmpObject.isAllowDivision , FALSE)  THEN TRUE ELSE FALSE ENd AS isErr_isAllowDivision  
          , tmpTab.isNotTransferTime AS isNotTransferTime_tab , tmpObject.isNotTransferTime, CASE WHEN COALESCE (tmpTab.isNotTransferTime, FALSE)  <> COALESCE (tmpObject.isNotTransferTime, FALSE) THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_isNotTransferTime, CASE WHEN COALESCE (tmpTab.isNotTransferTime, FALSE)  <> COALESCE (tmpObject.isNotTransferTime, FALSE) THEN TRUE ELSE FALSE ENd AS isErr_isNotTransferTime --28
                                                                                                                                                                                                                                                                                                                                                                                                                                                             
          , tmpTab.isNotMarion       AS isNotMarion_tab       , tmpObject.isNotMarion      , CASE WHEN COALESCE (tmpTab.isNotMarion, FALSE)        <> COALESCE (tmpObject.isNotMarion , FALSE)      THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_isNotMarion      , CASE WHEN COALESCE (tmpTab.isNotMarion, FALSE)        <> COALESCE (tmpObject.isNotMarion , FALSE)      THEN TRUE ELSE FALSE ENd AS isErr_isNotMarion      
          , tmpTab.isNOT             AS isNOT_tab             , tmpObject.isNOT            , CASE WHEN COALESCE (tmpTab.isNOT, FALSE)              <> COALESCE (tmpObject.isNOT , FALSE)            THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_isNOT            , CASE WHEN COALESCE (tmpTab.isNOT, FALSE)              <> COALESCE (tmpObject.isNOT , FALSE)            THEN TRUE ELSE FALSE ENd AS isErr_isNOT            
          , tmpTab.GoodsGroupId      AS GoodsGroupId_tab      , tmpObject.GoodsGroupId     , CASE WHEN COALESCE (tmpTab.GoodsGroupId,0)            <> COALESCE (tmpObject.GoodsGroupId,0)           THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_GoodsGroupId     , CASE WHEN COALESCE (tmpTab.GoodsGroupId,0)            <> COALESCE (tmpObject.GoodsGroupId,0)           THEN TRUE ELSE FALSE ENd AS isErr_GoodsGroupId      --37
                                                                                                                                                                                                                                                                                                                                                                                                                                                             
          , tmpTab.MeasureId         AS MeasureId_tab         , tmpObject.MeasureId        , CASE WHEN COALESCE (tmpTab.MeasureId,0)               <> COALESCE (tmpObject.MeasureId,0)              THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_MeasureId        , CASE WHEN COALESCE (tmpTab.MeasureId,0)               <> COALESCE (tmpObject.MeasureId,0)              THEN TRUE ELSE FALSE ENd AS isErr_MeasureId        
          , tmpTab.NDSKindId         AS NDSKindId_tab         , tmpObject.NDSKindId        , CASE WHEN COALESCE (tmpTab.NDSKindId,0)               <> COALESCE (tmpObject.NDSKindId,0)              THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_NDSKindId        , CASE WHEN COALESCE (tmpTab.NDSKindId,0)               <> COALESCE (tmpObject.NDSKindId,0)              THEN TRUE ELSE FALSE ENd AS isErr_NDSKindId        
          , tmpTab.ExchangeId        AS ExchangeId_tab        , tmpObject.ExchangeId       , CASE WHEN COALESCE (tmpTab.ExchangeId,0)              <> COALESCE (tmpObject.ExchangeId,0)             THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_Exchange         , CASE WHEN COALESCE (tmpTab.ExchangeId,0)              <> COALESCE (tmpObject.ExchangeId,0)             THEN TRUE ELSE FALSE ENd AS isErr_Exchange          --46
                                                                                                                                                                                                                                                                                                                                                                                                                                                             
          , tmpTab.ConditionsKeepId  AS ConditionsKeepId_tab  , tmpObject.ConditionsKeepId , CASE WHEN COALESCE (tmpTab.ConditionsKeepId,0)        <> COALESCE (tmpObject.ConditionsKeepId,0)       THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_ConditionsKeepId , CASE WHEN COALESCE (tmpTab.ConditionsKeepId,0)        <> COALESCE (tmpObject.ConditionsKeepId,0)       THEN TRUE ELSE FALSE ENd AS isErr_ConditionsKeepId 
          , tmpTab.GoodsGroupPromoID AS GoodsGroupPromoId_tab , tmpObject.GoodsGroupPromoID, CASE WHEN COALESCE (tmpTab.GoodsGroupPromoID,0)       <> COALESCE (tmpObject.GoodsGroupPromoID,0)      THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_GoodsGroupPromoId, CASE WHEN COALESCE (tmpTab.GoodsGroupPromoID,0)       <> COALESCE (tmpObject.GoodsGroupPromoID,0)      THEN TRUE ELSE FALSE ENd AS isErr_GoodsGroupPromoID
          , tmpTab.ReferCode         AS ReferCode_tab         , tmpObject.ReferCode        , CASE WHEN COALESCE (tmpTab.ReferCode,0)               <> COALESCE (tmpObject.ReferCode,0)              THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_ReferCode        , CASE WHEN COALESCE (tmpTab.ReferCode,0)               <> COALESCE (tmpObject.ReferCode,0)              THEN TRUE ELSE FALSE ENd AS isErr_ReferCode         --55
                                                                                                                                                                                                                                                                                                                                                                                                                                                             
          , tmpTab.ReferPrice        AS ReferPrice_tab        , tmpObject.ReferPrice       , CASE WHEN COALESCE (tmpTab.ReferPrice,0)              <> COALESCE (tmpObject.ReferPrice,0)             THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_ReferPrice       , CASE WHEN COALESCE (tmpTab.ReferPrice,0)              <> COALESCE (tmpObject.ReferPrice,0)             THEN TRUE ELSE FALSE ENd AS isErr_ReferPrice       
          , tmpTab.CountPrice        AS CountPrice_tab        , tmpObject.CountPrice       , CASE WHEN COALESCE (tmpTab.CountPrice,0)              <> COALESCE (tmpObject.CountPrice,0)             THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_CountPrice       , CASE WHEN COALESCE (tmpTab.CountPrice,0)              <> COALESCE (tmpObject.CountPrice,0)             THEN TRUE ELSE FALSE ENd AS isErr_CountPrice       
          , tmpTab.LastPrice         AS LastPrice_tab         , tmpObject.LastPrice        , CASE WHEN COALESCE (tmpTab.LastPrice ,Null)           <> COALESCE (tmpObject.LastPrice ,Null)          THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_LastPrice        , CASE WHEN COALESCE (tmpTab.LastPrice ,Null)           <> COALESCE (tmpObject.LastPrice ,Null)          THEN TRUE ELSE FALSE ENd AS isErr_LastPrice         --64
                                                                                                                                                                                                                                                                                                                                                                                                                                                             
          , tmpTab.LastPriceOld      AS LastPriceOld_tab      , tmpObject.LastPriceOld     , CASE WHEN COALESCE (tmpTab.LastPriceOld,Null)         <> COALESCE (tmpObject.LastPriceOld,Null)        THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_LastPriceOld     , CASE WHEN COALESCE (tmpTab.LastPriceOld,Null)         <> COALESCE (tmpObject.LastPriceOld,Null)        THEN TRUE ELSE FALSE ENd AS isErr_LastPriceOld     
          , tmpTab.MakerName         AS MakerName_tab         , tmpObject.MakerName ::TvarChar , CASE WHEN COALESCE (tmpTab.MakerName,'')          <> COALESCE (tmpObject.MakerName ,'')            THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_MakerName        , CASE WHEN COALESCE (tmpTab.MakerName,'')              <> COALESCE (tmpObject.MakerName ,'')            THEN TRUE ELSE FALSE ENd AS isErr_MakerName
          , tmpTab.NameUkr           AS NameUkr_tab           , tmpObject.NameUkr   ::TvarChar , CASE WHEN COALESCE (tmpTab.NameUkr,'')            <> COALESCE (tmpObject.NameUkr,'')               THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_NameUkr          , CASE WHEN COALESCE (tmpTab.NameUkr,'')                <> COALESCE (tmpObject.NameUkr,'')               THEN TRUE ELSE FALSE ENd AS isErr_NameUkr           --73

          , tmpTab.CodeUKTZED        AS CodeUKTZED_tab        , tmpObject.CodeUKTZED::TvarChar   , CASE WHEN COALESCE (tmpTab.CodeUKTZED,'')       <> COALESCE (tmpObject.CodeUKTZED,'')            THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_CodeUKTZED       , CASE WHEN COALESCE (tmpTab.CodeUKTZED,'')             <> COALESCE (tmpObject.CodeUKTZED,'')            THEN TRUE ELSE FALSE ENd AS isErr_CodeUKTZED       
          , tmpTab.Analog            AS Analog_tab            , tmpObject.Analog           , CASE WHEN COALESCE (tmpTab.Analog,'')                 <> COALESCE (tmpObject.Analog,'')                THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_Analog           , CASE WHEN COALESCE (tmpTab.Analog,'')                 <> COALESCE (tmpObject.Analog,'')                THEN TRUE ELSE FALSE ENd AS isErr_Analog       
          , tmpTab.isPublished       AS isPublished_tab       , tmpObject.isPublished      , CASE WHEN COALESCE (tmpTab.isPublished, FALSE)        <> COALESCE (tmpObject.isPublished, FALSE)       THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_isPublished      , CASE WHEN COALESCE (tmpTab.isPublished, FALSE)        <> COALESCE (tmpObject.isPublished, FALSE)       THEN TRUE ELSE FALSE ENd AS isErr_isPublished       --82
                                                                                                                                                                                                                                                                                                                                                                                                                                                         
          , tmpTab.SiteKey           AS SiteKey_tab           , tmpObject.SiteKey          , CASE WHEN COALESCE (tmpTab.SiteKey,0)                 <> COALESCE (tmpObject.SiteKey,0)                THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_SiteKey          , CASE WHEN COALESCE (tmpTab.SiteKey,0)                 <> COALESCE (tmpObject.SiteKey,0)                THEN TRUE ELSE FALSE ENd AS isErr_SiteKey      
          , tmpTab.Foto              AS Foto_tab              , tmpObject.Foto             , CASE WHEN COALESCE (tmpTab.Foto,'')                   <> COALESCE (tmpObject.Foto,'')                  THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_Foto             , CASE WHEN COALESCE (tmpTab.Foto,'')                   <> COALESCE (tmpObject.Foto,'')                  THEN TRUE ELSE FALSE ENd AS isErr_Foto         
          , tmpTab.Thumb             AS Thumb_tab             , tmpObject.Thumb            , CASE WHEN COALESCE (tmpTab.Thumb,'')                  <> COALESCE (tmpObject.Thumb ,'')                THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_Thumb            , CASE WHEN COALESCE (tmpTab.Thumb,'')                  <> COALESCE (tmpObject.Thumb ,'')                THEN TRUE ELSE FALSE ENd AS isErr_Thumb             --91
                                                                                                                                                                                                                                                                                                                                                                                                                                                         
          , tmpTab.AppointmentId     AS AppointmentId_tab     , tmpObject.AppointmentId    , CASE WHEN COALESCE (tmpTab.AppointmentId,0)           <> COALESCE (tmpObject.AppointmentId,0)          THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_AppointmentId    , CASE WHEN COALESCE (tmpTab.AppointmentId,0)           <> COALESCE (tmpObject.AppointmentId,0)          THEN TRUE ELSE FALSE ENd AS isErr_AppointmentId
      FROM tmpTab
           LEFT JOIN tmpObject ON tmpTab.Id = tmpObject.Id               
      WHERE tmpTab.ObjectCode   <> tmpObject.ObjectCode        
         OR COALESCE (tmpTab.Name,'')                   <> COALESCE (tmpObject.Name, '')
         OR COALESCE (tmpTab.MorionCode,0)              <> COALESCE (tmpObject.MorionCode ,0)
         OR COALESCE (tmpTab.isErased, FALSE)           <> COALESCE (tmpObject.isErased , FALSE)         
         OR COALESCE (tmpTab.isClose, FALSE)            <> COALESCE (tmpObject.isClose , FALSE)          
         OR COALESCE (tmpTab.isNotUploadSites, FALSE)   <> COALESCE (tmpObject.isNotUploadSites , FALSE) 
         OR COALESCE (tmpTab.isDoesNotShare, FALSE)     <> COALESCE (tmpObject.isDoesNotShare , FALSE)   
         OR COALESCE (tmpTab.isAllowDivision, FALSE)    <> COALESCE (tmpObject.isAllowDivision , FALSE)  
         OR COALESCE (tmpTab.isNotTransferTime, FALSE)  <> COALESCE (tmpObject.isNotTransferTime, FALSE) 
         OR COALESCE (tmpTab.isNotMarion, FALSE)        <> COALESCE (tmpObject.isNotMarion , FALSE)      
         OR COALESCE (tmpTab.isNOT, FALSE)              <> COALESCE (tmpObject.isNOT , FALSE)            
         OR COALESCE (tmpTab.GoodsGroupId,0)            <> COALESCE (tmpObject.GoodsGroupId,0)     
         OR COALESCE (tmpTab.MeasureId,0)               <> COALESCE (tmpObject.MeasureId,0)        
         OR COALESCE (tmpTab.NDSKindId,0)               <> COALESCE (tmpObject.NDSKindId,0)        
         OR COALESCE (tmpTab.ExchangeId,0)              <> COALESCE (tmpObject.ExchangeId,0)         
         OR COALESCE (tmpTab.ConditionsKeepId,0)        <> COALESCE (tmpObject.ConditionsKeepId,0)
         OR COALESCE (tmpTab.GoodsGroupPromoID,0)       <> COALESCE (tmpObject.GoodsGroupPromoID,0)
         OR COALESCE (tmpTab.ReferCode,0)               <> COALESCE (tmpObject.ReferCode,0)        
         OR COALESCE (tmpTab.ReferPrice,0)              <> COALESCE (tmpObject.ReferPrice,0)       
         OR COALESCE (tmpTab.CountPrice,0)              <> COALESCE (tmpObject.CountPrice,0)       
         OR COALESCE (tmpTab.LastPrice ,Null)           <> COALESCE (tmpObject.LastPrice ,Null)       
         OR COALESCE (tmpTab.LastPriceOld,Null)         <> COALESCE (tmpObject.LastPriceOld,Null)     
         OR COALESCE (tmpTab.MakerName,'')              <> COALESCE (tmpObject.MakerName ,'')       
         OR COALESCE (tmpTab.NameUkr,'')                <> COALESCE (tmpObject.NameUkr,'')          
         OR COALESCE (tmpTab.CodeUKTZED,'')             <> COALESCE (tmpObject.CodeUKTZED,'')       
         OR COALESCE (tmpTab.Analog,'')                 <> COALESCE (tmpObject.Analog,'')           
         OR COALESCE (tmpTab.isPublished, FALSE)        <> COALESCE (tmpObject.isPublished, FALSE)         
         OR COALESCE (tmpTab.SiteKey,0)                 <> COALESCE (tmpObject.SiteKey,0)          
         OR COALESCE (tmpTab.Foto,'')                   <> COALESCE (tmpObject.Foto,'')             
         OR COALESCE (tmpTab.Thumb,'')                  <> COALESCE (tmpObject.Thumb ,'')           
         OR COALESCE (tmpTab.AppointmentId,0)           <> COALESCE (tmpObject.AppointmentId,0)
       
      ;


     OPEN Cursor1 FOR

       SELECT tmpData.Id 
            , tmpData.ObjectCode_tab        AS  ObjectCode           , tmpData.Color_Code              , tmpData.isErr_Code             
            , tmpData.Name_tab              AS  Name                 , tmpData.Color_Name              , tmpData.isErr_Name             
            , tmpData.MorionCode_tab        AS  MorionCode           , tmpData.Color_MorionCode        , tmpData.isErr_MorionCode       
                                                                                                                                        
            , tmpData.isErased_tab          AS  isErased             , tmpData.Color_isErased          , tmpData.isErr_isErased         
            , tmpData.isClose_tab           AS  isClose              , tmpData.Color_isClose           , tmpData.isErr_isClose          
            , tmpData.isNotUploadSites_tab  AS  isNotUploadSites     , tmpData.Color_isNotUploadSites  , tmpData.isErr_isNotUploadSites 
                                                                                                                                        
            , tmpData.isDoesNotShare_tab    AS  isDoesNotShare       , tmpData.Color_isDoesNotShare    , tmpData.isErr_isDoesNotShare   
            , tmpData.isAllowDivision_tab   AS  isAllowDivision      , tmpData.Color_isAllowDivision   , tmpData.isErr_isAllowDivision  
            , tmpData.isNotTransferTime_tab AS  isNotTransferTime    , tmpData.Color_isNotTransferTime , tmpData.isErr_isNotTransferTime
                                                                                                                                        
            , tmpData.isNotMarion_tab       AS  isNotMarion          , tmpData.Color_isNotMarion       , tmpData.isErr_isNotMarion      
            , tmpData.isNOT_tab             AS  isNOT                , tmpData.Color_isNOT             , tmpData.isErr_isNOT            
            , Object_GoodsGroup.ValueData   AS  GoodsGroupName       , tmpData.Color_GoodsGroupId      , tmpData.isErr_GoodsGroupId     
                                                                                                                                        
            , Object_Measure.ValueData      AS  MeasureName          , tmpData.Color_MeasureId         , tmpData.isErr_MeasureId        
            , Object_NDSKind.ValueData      AS  NDSKindName          , tmpData.Color_NDSKindId         , tmpData.isErr_NDSKindId        
            , Object_Exchange.ValueData     AS  ExchangeName         , tmpData.Color_Exchange          , tmpData.isErr_Exchange         
                                                                                                                                        
            , Object_ConditionsKeep.ValueData  AS ConditionsKeepName , tmpData.Color_ConditionsKeepId  , tmpData.isErr_ConditionsKeepId 
            , Object_GoodsGroupPromo.ValueData AS GoodsGroupPromoName, tmpData.Color_GoodsGroupPromoId , tmpData.isErr_GoodsGroupPromoID
            , tmpData.ReferCode_tab         AS  ReferCode            , tmpData.Color_ReferCode         , tmpData.isErr_ReferCode        
                                                                                                                                        
            , tmpData.ReferPrice_tab        AS  ReferPrice           , tmpData.Color_ReferPrice        , tmpData.isErr_ReferPrice       
            , tmpData.CountPrice_tab        AS  CountPrice           , tmpData.Color_CountPrice        , tmpData.isErr_CountPrice       
            , tmpData.LastPrice_tab         AS  LastPrice            , tmpData.Color_LastPrice         , tmpData.isErr_LastPrice        
                                                                                                                                        
            , tmpData.LastPriceOld_tab      AS  LastPriceOld         , tmpData.Color_LastPriceOld      , tmpData.isErr_LastPriceOld     
            , tmpData.MakerName_tab         AS  MakerName            , tmpData.Color_MakerName         , tmpData.isErr_MakerName        
            , tmpData.NameUkr_tab           AS  NameUkr              , tmpData.Color_NameUkr           , tmpData.isErr_NameUkr          
                                                                                                                                        
            , tmpData.CodeUKTZED_tab        AS  CodeUKTZED           , tmpData.Color_CodeUKTZED        , tmpData.isErr_CodeUKTZED       
            , tmpData.Analog_tab            AS  Analog               , tmpData.Color_Analog            , tmpData.isErr_Analog           
            , tmpData.isPublished_tab       AS  isPublished          , tmpData.Color_isPublished       , tmpData.isErr_isPublished      
                                                                                                                                        
            , tmpData.SiteKey_tab           AS  SiteKey              , tmpData.Color_SiteKey           , tmpData.isErr_SiteKey          
            , tmpData.Foto_tab              AS  Foto                 , tmpData.Color_Foto              , tmpData.isErr_Foto             
            , tmpData.Thumb_tab             AS  Thumb                , tmpData.Color_Thumb             , tmpData.isErr_Thumb            
                                                                                                                                        
            , Object_Appointment.ValueData  AS  AppointmentName      , tmpData.Color_AppointmentId     , tmpData.isErr_AppointmentId    
       FROM tmpData
            LEFT JOIN Object AS Object_Measure         ON Object_Measure.Id         = tmpData.MeasureId_tab
            LEFT JOIN Object AS Object_NDSKind         ON Object_NDSKind.Id         = tmpData.NDSKindId_tab
            LEFT JOIN Object AS Object_Exchange        ON Object_Exchange.Id        = tmpData.ExchangeId_tab
            LEFT JOIN Object AS Object_GoodsGroup      ON Object_GoodsGroup.Id      = tmpData.GoodsGroupId_tab
            LEFT JOIN Object AS Object_ConditionsKeep  ON Object_ConditionsKeep.Id  = tmpData.ConditionsKeepId_tab
            LEFT JOIN Object AS Object_GoodsGroupPromo ON Object_GoodsGroupPromo.Id = tmpData.GoodsGroupPromoId_tab
            LEFT JOIN Object AS Object_Appointment     ON Object_Appointment.Id     = tmpData.AppointmentId_tab
                   ; 
     RETURN NEXT Cursor1;


     -- Результат 2
     OPEN Cursor2 FOR
       SELECT tmpData.Id 
            , tmpData.ObjectCode       
            , tmpData.Name             
            , tmpData.MorionCode       
           
            , tmpData.isErased         
            , tmpData.isClose          
            , tmpData.isNotUploadSites 
            
            , tmpData.isDoesNotShare   
            , tmpData.isAllowDivision  
            , tmpData.isNotTransferTime
            
            , tmpData.isNotMarion      
            , tmpData.isNOT            
            , Object_GoodsGroup.ValueData   AS  GoodsGroupName     
 
            , Object_Measure.ValueData      AS  MeasureName 
            , Object_NDSKind.ValueData      AS  NDSKindName 
            , Object_Exchange.ValueData     AS  ExchangeName
                   
            , Object_ConditionsKeep.ValueData  AS ConditionsKeepName
            , Object_GoodsGroupPromo.ValueData AS GoodsGroupPromoName
            , tmpData.ReferCode        
 
            , tmpData.ReferPrice       
            , tmpData.CountPrice       
            , tmpData.LastPrice        
 
            , tmpData.LastPriceOld     
            , tmpData.MakerName ::TvarChar
            , tmpData.NameUkr   ::TvarChar
 
            , tmpData.CodeUKTZED::TvarChar
            , tmpData.Analog
            , tmpData.isPublished  
 
            , tmpData.SiteKey      
            , tmpData.Foto         
            , tmpData.Thumb        
 
            , Object_Appointment.ValueData  AS AppointmentName 
       FROM tmpData
            LEFT JOIN Object AS Object_Measure         ON Object_Measure.Id         = tmpData.MeasureId
            LEFT JOIN Object AS Object_NDSKind         ON Object_NDSKind.Id         = tmpData.NDSKindId
            LEFT JOIN Object AS Object_Exchange        ON Object_Exchange.Id        = tmpData.ExchangeId
            LEFT JOIN Object AS Object_GoodsGroup      ON Object_GoodsGroup.Id      = tmpData.GoodsGroupId
            LEFT JOIN Object AS Object_ConditionsKeep  ON Object_ConditionsKeep.Id  = tmpData.ConditionsKeepId
            LEFT JOIN Object AS Object_GoodsGroupPromo ON Object_GoodsGroupPromo.Id = tmpData.GoodsGroupPromoId
            LEFT JOIN Object AS Object_Appointment     ON Object_Appointment.Id     = tmpData.AppointmentId
       ;
     RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.11.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsMain_ErrorTab (zfCalc_UserAdmin())