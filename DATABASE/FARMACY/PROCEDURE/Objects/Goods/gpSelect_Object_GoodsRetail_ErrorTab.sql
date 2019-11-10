-- Function: gpSelect_Object_GoodsRetail_ErrorTab()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsRetail_ErrorTab(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsRetail_ErrorTab(
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
                            , ObjectCode_tab    Integer
                            , Name_tab          TVarChar
                            , isErased_tab      Boolean
                            , GoodsMainId_tab   Integer  , GoodsMainId   Integer  , Color_GoodsMainId   Integer, isErr_GoodsMainId   Boolean

                            , isTOP_tab         Boolean  , isTOP         Boolean  , Color_isTOP         Integer, isErr_isTOP         Boolean
                            , isFirst_tab       Boolean  , isFirst       Boolean  , Color_isFirst       Integer, isErr_isFirst       Boolean
                            , isSecond_tab      Boolean  , isSecond      Boolean  , Color_isSecond      Integer, isErr_isSecond      Boolean
                            
                            , MinimumLot_tab    TFloat   , MinimumLot    TFloat   , Color_MinimumLot    Integer, isErr_MinimumLot    Boolean
                            , PercentMarkup_tab TFloat   , PercentMarkup TFloat   , Color_PercentMarkup Integer, isErr_PercentMarkup Boolean
                            , Price_tab         TFloat   , Price         TFloat   , Color_Price         Integer, isErr_Price         Boolean                            
                           
                            , RetailId_tab      integer  , RetailId      Integer  , Color_RetailId      Integer, isErr_RetailId      Boolean
                            
                            , UserInsertId_tab  integer  , UserInsertId  Integer  , Color_UserInsertId  Integer, isErr_UserInsertId  Boolean
                            , UserUpdateId_tab  integer  , UserUpdateId  Integer  , Color_UserUpdateId  Integer, isErr_UserUpdateId  Boolean

                            , DateInsert_tab    TDateTime, DateInsert    TDateTime, Color_DateInsert    Integer, isErr_DateInsert    Boolean
                            , DateUpdate_tab    TDateTime, DateUpdate    TDateTime, Color_DateUpdate    Integer, isErr_DateUpdate    Boolean
                            ) ON COMMIT DROP;

         INSERT INTO tmpData (Id
                            , ObjectCode_tab           
                            , Name_tab     
                            , isErased_tab
                            , GoodsMainId_tab   , GoodsMainId  , Color_GoodsMainId   , isErr_GoodsMainId       
                            , isTOP_tab         , isTOP        , Color_isTOP         , isErr_isTOP          
                            , isFirst_tab       , isFirst      , Color_isFirst       , isErr_isFirst 
                            , isSecond_tab      , isSecond     , Color_isSecond      , isErr_isSecond   
                            , MinimumLot_tab    , MinimumLot   , Color_MinimumLot    , isErr_MinimumLot  
                            , PercentMarkup_tab , PercentMarkup, Color_PercentMarkup , isErr_PercentMarkup
                            , Price_tab         , Price        , Color_Price         , isErr_Price       
                            , RetailId_tab      , RetailId     , Color_RetailId      , isErr_RetailId     
                            , UserInsertId_tab  , UserInsertId , Color_UserInsertId  , isErr_UserInsertId        
                            , UserUpdateId_tab  , UserUpdateId , Color_UserUpdateId  , isErr_UserUpdateId        
                            , DateInsert_tab    , DateInsert   , Color_DateInsert    , isErr_DateInsert        
                            , DateUpdate_tab    , DateUpdate   , Color_DateUpdate    , isErr_DateUpdate     
                            )

   WITH tmpObject AS (SELECT Object_Goods.Id
                           , Object_Goods.ObjectCode
                           , Object_Goods.ValueData                           AS Name
                           , Object_Goods.isErased
                           , ObjectLink_Main.ChildObjectId                    AS GoodsMainId
                           , ObjectLink_Goods_Object.ChildObjectId            AS RetailId
                           , ObjectFloat_Goods_MinimumLot.ValueData           AS MinimumLot
                           , ObjectFloat_Goods_PercentMarkup.ValueData        AS PercentMarkup
                           , ObjectFloat_Goods_Price.ValueData                AS Price
                           , COALESCE(ObjectBoolean_Goods_TOP.ValueData, FALSE)      AS TOP
                           , COALESCE(ObjectBoolean_Goods_First.ValueData, FALSE)    AS First
                           , COALESCE(ObjectBoolean_Goods_Second.ValueData, FALSE)   AS Second
                           , ObjectLink_Protocol_Insert.ChildObjectId         AS UserInsert
                           , ObjectLink_Protocol_Update.ChildObjectId         AS UserUpdate
                           , ObjectDate_Protocol_Insert.ValueData             AS DateInsert
                           , ObjectDate_Protocol_Update.ValueData             AS DateUpdate
                
                      FROM Object AS Object_Goods
                         -- получается GoodsMainId
                         LEFT JOIN  ObjectLink AS ObjectLink_Child 
                                               ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                                              AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                         LEFT JOIN  ObjectLink AS ObjectLink_Main
                                               ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                              AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                
                         LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                              ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                                             AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                         LEFT JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = ObjectLink_Goods_Object.ChildObjectId
                         --LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId
                
                         LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PercentMarkup
                                               ON ObjectFloat_Goods_PercentMarkup.ObjectId = Object_Goods.Id
                                              AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()
                         LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Price
                                               ON ObjectFloat_Goods_Price.ObjectId = Object_Goods.Id
                                              AND ObjectFloat_Goods_Price.DescId = zc_ObjectFloat_Goods_Price()
                
                         LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                 ON ObjectBoolean_Goods_TOP.ObjectId = Object_Goods.Id
                                                AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
                
                         LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_First
                                                 ON ObjectBoolean_Goods_First.ObjectId = Object_Goods.Id
                                                AND ObjectBoolean_Goods_First.DescId = zc_ObjectBoolean_Goods_First()
                
                         LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Second
                                                 ON ObjectBoolean_Goods_Second.ObjectId = Object_Goods.Id
                                                AND ObjectBoolean_Goods_Second.DescId = zc_ObjectBoolean_Goods_Second()
                
                         LEFT JOIN ObjectLink AS ObjectLink_Protocol_Insert
                                              ON ObjectLink_Protocol_Insert.ObjectId = Object_Goods.Id
                                             AND ObjectLink_Protocol_Insert.DescId = zc_ObjectLink_Protocol_Insert()
                
                         LEFT JOIN ObjectLink AS ObjectLink_Protocol_Update
                                              ON ObjectLink_Protocol_Update.ObjectId = Object_Goods.Id
                                             AND ObjectLink_Protocol_Update.DescId = zc_ObjectLink_Protocol_Update()
                
                         LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                                              ON ObjectDate_Protocol_Insert.ObjectId = Object_Goods.Id
                                             AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
                
                         LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                                              ON ObjectDate_Protocol_Update.ObjectId = Object_Goods.Id
                                             AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()
                
                         LEFT JOIN ObjectFloat AS ObjectFloat_Goods_MinimumLot
                                               ON ObjectFloat_Goods_MinimumLot.ObjectId = Object_Goods.Id
                                              AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()

                    WHERE Object_Goods.DescId = zc_Object_Goods()
                      AND Object_GoodsObject.DescId = zc_Object_Retail()
                   )

      -- сохраненные данные
      , tmpTab AS (SELECT Object_Goods_Retail.*
                   FROM Object_Goods_Retail
                   )

     -- Результат
     SELECT tmpTab.Id 
          , tmpTab.ObjectCode    AS ObjectCode_tab
          , tmpTab.Name          AS Name_tab
          , tmpTab.isErased      AS isErased_tab
          , tmpTab.GoodsMainId   AS GoodsMainId_tab  , tmpObject.GoodsMainId  , CASE WHEN COALESCE (tmpTab.GoodsMainId,0)        <> COALESCE (tmpObject.GoodsMainId ,0)       THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_GoodsMainId  , CASE WHEN COALESCE (tmpTab.GoodsMainId,0)        <> COALESCE (tmpObject.GoodsMainId ,0)       THEN TRUE ELSE FALSE ENd AS isErr_GoodsMainId
          , tmpTab.isTOP         AS isTOP_tab        , tmpObject.isTOP        , CASE WHEN COALESCE (tmpTab.isTOP, FALSE)         <> COALESCE (tmpObject.isTOP , FALSE)        THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_isTOP        , CASE WHEN COALESCE (tmpTab.isTOP, FALSE)         <> COALESCE (tmpObject.isTOP , FALSE)        THEN TRUE ELSE FALSE ENd AS isErr_isTOP
          , tmpTab.isFirst       AS isFirst_tab      , tmpObject.isFirst      , CASE WHEN COALESCE (tmpTab.isFirst, FALSE)       <> COALESCE (tmpObject.isFirst , FALSE)      THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_isFirst      , CASE WHEN COALESCE (tmpTab.isFirst, FALSE)       <> COALESCE (tmpObject.isFirst , FALSE)      THEN TRUE ELSE FALSE ENd AS isErr_isFirst
          , tmpTab.isSecond      AS isSecond_tab     , tmpObject.isSecond     , CASE WHEN COALESCE (tmpTab.isSecond, FALSE)      <> COALESCE (tmpObject.isSecond , FALSE)     THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_isSecond     , CASE WHEN COALESCE (tmpTab.isSecond, FALSE)      <> COALESCE (tmpObject.isSecond , FALSE)     THEN TRUE ELSE FALSE ENd AS isErr_isSecond
          , tmpTab.MinimumLot    AS MinimumLot_tab   , tmpObject.MinimumLot   , CASE WHEN COALESCE (tmpTab.MinimumLot, FALSE)    <> COALESCE (tmpObject.MinimumLot , FALSE)   THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_MinimumLot   , CASE WHEN COALESCE (tmpTab.MinimumLot, FALSE)    <> COALESCE (tmpObject.MinimumLot , FALSE)   THEN TRUE ELSE FALSE ENd AS isErr_MinimumLot
          , tmpTab.PercentMarkup AS PercentMarkup_tab, tmpObject.PercentMarkup, CASE WHEN COALESCE (tmpTab.PercentMarkup, FALSE) <> COALESCE (tmpObject.PercentMarkup, FALSE) THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_PercentMarkup, CASE WHEN COALESCE (tmpTab.PercentMarkup, FALSE) <> COALESCE (tmpObject.PercentMarkup, FALSE) THEN TRUE ELSE FALSE ENd AS isErr_PercentMarkup
          , tmpTab.Price         AS Price_tab        , tmpObject.Price        , CASE WHEN COALESCE (tmpTab.Price,0)              <> COALESCE (tmpObject.Price,0)              THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_Price        , CASE WHEN COALESCE (tmpTab.Price,0)              <> COALESCE (tmpObject.Price,0)              THEN TRUE ELSE FALSE ENd AS isErr_Price
          , tmpTab.RetailId      AS RetailId_tab     , tmpObject.RetailId     , CASE WHEN COALESCE (tmpTab.RetailId,0)           <> COALESCE (tmpObject.RetailId,0)           THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_RetailId     , CASE WHEN COALESCE (tmpTab.RetailId,0)           <> COALESCE (tmpObject.RetailId,0)           THEN TRUE ELSE FALSE ENd AS isErr_RetailId
          , tmpTab.UserInsertId  AS UserInsertId_tab , tmpObject.UserInsertId , CASE WHEN COALESCE (tmpTab.UserInsertId,0)       <> COALESCE (tmpObject.UserInsertId,0)       THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_UserInsertId , CASE WHEN COALESCE (tmpTab.UserInsertId,0)       <> COALESCE (tmpObject.UserInsertId,0)       THEN TRUE ELSE FALSE ENd AS isErr_UserInsertId
          , tmpTab.UserUpdateId  AS UserUpdateId_tab , tmpObject.UserUpdateId , CASE WHEN COALESCE (tmpTab.UserUpdateId,0)       <> COALESCE (tmpObject.UserUpdateId,0)       THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_UserUpdateId , CASE WHEN COALESCE (tmpTab.UserUpdateId,0)       <> COALESCE (tmpObject.UserUpdateId,0)       THEN TRUE ELSE FALSE ENd AS isErr_UserUpdateId
          , tmpTab.DateInsert    AS DateInsert_tab   , tmpObject.DateInsert   , CASE WHEN COALESCE (tmpTab.DateInsert ,Null)     <> COALESCE (tmpObject.DateInsert ,Null)     THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_DateInsert   , CASE WHEN COALESCE (tmpTab.DateInsert ,Null)     <> COALESCE (tmpObject.DateInsert ,Null)     THEN TRUE ELSE FALSE ENd AS isErr_DateInsert
          , tmpTab.DateUpdate    AS DateUpdate_tab   , tmpObject.DateUpdate   , CASE WHEN COALESCE (tmpTab.DateUpdate,Null)      <> COALESCE (tmpObject.DateUpdate,Null)      THEN zc_Color_Red() ELSE zc_Color_White() ENd AS Color_DateUpdate   , CASE WHEN COALESCE (tmpTab.DateUpdate,Null)      <> COALESCE (tmpObject.DateUpdate,Null)      THEN TRUE ELSE FALSE ENd AS isErr_DateUpdate
      FROM tmpTab
           LEFT JOIN tmpObject ON tmpTab.Id = tmpObject.Id               
      WHERE COALESCE (tmpTab.GoodsMainId,0)        <> COALESCE (tmpObject.GoodsMainId ,0)
         OR COALESCE (tmpTab.isTOP, FALSE)         <> COALESCE (tmpObject.isTOP , FALSE)
         OR COALESCE (tmpTab.isFirst, FALSE)       <> COALESCE (tmpObject.isFirst , FALSE)
         OR COALESCE (tmpTab.isSecond, FALSE)      <> COALESCE (tmpObject.isSecond , FALSE)
         OR COALESCE (tmpTab.MinimumLot, FALSE)    <> COALESCE (tmpObject.MinimumLot , FALSE)
         OR COALESCE (tmpTab.PercentMarkup, FALSE) <> COALESCE (tmpObject.PercentMarkup, FALSE)
         OR COALESCE (tmpTab.Price,0)              <> COALESCE (tmpObject.Price,0)
         OR COALESCE (tmpTab.RetailId,0)           <> COALESCE (tmpObject.RetailId,0)
         OR COALESCE (tmpTab.UserInsertId,0)       <> COALESCE (tmpObject.UserInsertId,0)
         OR COALESCE (tmpTab.UserUpdateId,0)       <> COALESCE (tmpObject.UserUpdateId,0)
         OR COALESCE (tmpTab.DateInsert ,Null)     <> COALESCE (tmpObject.DateInsert ,Null)
         OR COALESCE (tmpTab.DateUpdate,Null)      <> COALESCE (tmpObject.DateUpdate,Null)
      ;


     OPEN Cursor1 FOR

       SELECT tmpData.Id 
            , tmpData.ObjectCode_tab    AS  ObjectCode
            , tmpData.Name_tab          AS  Name
            , tmpData.isErased_tab      AS  isErased
            , tmpData.GoodsMainId_tab   AS  GoodsMainId      , tmpData.Color_GoodsMainId   , tmpData.isErr_GoodsMainId
            , tmpData.isTOP_tab         AS  isTOP            , tmpData.Color_isTOP         , tmpData.isErr_isTOP
            , tmpData.isFirst_tab       AS  isFirst          , tmpData.Color_isFirst       , tmpData.isErr_isFirst
            , tmpData.isSecond_tab      AS  isSecond         , tmpData.Color_isSecond      , tmpData.isErr_isSecond
            , tmpData.MinimumLot_tab    AS  MinimumLot       , tmpData.Color_MinimumLot    , tmpData.isErr_MinimumLot
            , tmpData.PercentMarkup_tab AS  PercentMarkup    , tmpData.Color_PercentMarkup , tmpData.isErr_PercentMarkup
            , tmpData.Price_tab         AS  Price            , tmpData.Color_Price         , tmpData.isErr_Price
            , Object_Retail.ValueData   AS  RetailName       , tmpData.Color_RetailId      , tmpData.isErr_RetailId
            , Object_UserInsert.ValueData AS  UserInsertName , tmpData.Color_UserInsertId  , tmpData.isErr_UserInsertId
            , Object_UserUpdate.ValueData AS  UserUpdateName , tmpData.Color_UserUpdateId  , tmpData.isErr_UserUpdateId
            , tmpData.DateInsert_tab      AS  DateInsert     , tmpData.Color_DateInsert    , tmpData.isErr_DateInsert
            , tmpData.DateUpdate_tab      AS  DateUpdate     , tmpData.Color_DateUpdate    , tmpData.isErr_DateUpdate
       FROM tmpData
            LEFT JOIN Object AS Object_UserInsert         ON Object_UserInsert.Id         = tmpData.UserInsertId_tab
            LEFT JOIN Object AS Object_UserUpdate         ON Object_UserUpdate.Id         = tmpData.UserUpdateId_tab
            LEFT JOIN Object AS Object_Retail      ON Object_Retail.Id      = tmpData.RetailId_tab
                   ; 
     RETURN NEXT Cursor1;

     -- Результат 2
     OPEN Cursor2 FOR
       SELECT tmpData.Id 
            , tmpData.GoodsMainId
            , tmpData.isTOP
            , tmpData.isFirst
            , tmpData.isSecond
            , tmpData.MinimumLot
            , tmpData.PercentMarkup
            , tmpData.Price
            , Object_Retail.ValueData     AS RetailName
            , Object_UserInsert.ValueData AS UserInsertName
            , Object_UserUpdate.ValueData AS UserUpdateName
            , tmpData.DateInsert
            , tmpData.DateUpdate
       FROM tmpData
            LEFT JOIN Object AS Object_UserInsert  ON Object_UserInsert.Id = tmpData.UserInsertId
            LEFT JOIN Object AS Object_UserUpdate  ON Object_UserUpdate.Id = tmpData.UserUpdateId
            LEFT JOIN Object AS Object_Retail      ON Object_Retail.Id     = tmpData.RetailId
       ;
     RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.11.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsRetail_ErrorTab (zfCalc_UserAdmin())