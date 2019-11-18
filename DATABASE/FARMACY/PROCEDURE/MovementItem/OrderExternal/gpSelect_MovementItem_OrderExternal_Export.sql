-- Function: gpSelect_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderExternal_Export (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderExternal_Export(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)

RETURNS SETOF refcursor 

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbJuridicalId Integer;
  DECLARE vbOKPO TVarChar;
  DECLARE vbUnitCode Integer;

  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderExternal());
     vbUserId := inSession;

     SELECT Movement_OrderExternal_View.FromId
          , ObjectHistoryString_JuridicalDetails_OKPO.ValueData AS OKPO  -- нашего юр.лица
          , Movement_OrderExternal_View.ToCode
   INTO vbJuridicalId, vbOKPO, vbUnitCode
     FROM Movement_OrderExternal_View
          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                        ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = Movement_OrderExternal_View.JuridicalId
                                       AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
     WHERE Movement_OrderExternal_View.Id = inMovementId;



     IF vbJuridicalId = 59611 THEN --Оптима


     OPEN Cursor1 FOR
       SELECT ''::TVarChar AS FieldName, ''::TVarChar AS DisplayName;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
       SELECT            
             ''::VarChar(10)                        AS Field1
           , ''::VarChar(10)                        AS Field2
           , ''::VarChar(10)                        AS Field3
           , MovementItem.Amount                    as ZAKAZ
           , ''::VarChar(10)                        AS Field4
           , ''::VarChar(10)                        AS Field5
           , ''::VarChar(10)                        AS Field6
           , MovementItem.PartnerGoodsCode::Integer as KOD
           
        FROM Movement_OrderExternal_View AS Movement
         LEFT JOIN (SELECT DISTINCT IntegerKey, MainId, ValueId FROM Object_ImportExportLink_View AS PointKey WHERE PointKey.LinkTypeId = zc_Enum_ImportExportLinkType_UnitJuridical()
                                               LIMIT 1 ) AS PointKey ON PointKey.MainId = Movement.ToId
                                                            AND PointKey.ValueId = Movement.FromId
         LEFT JOIN Object_Unit_View AS Unit ON Unit.Id = Movement.ToId 
         LEFT JOIN Object_ImportExportLink_View AS JuridicalKey ON JuridicalKey.LinkTypeId = zc_Enum_ImportExportLinkType_UnitJuridical()
                                               AND JuridicalKey.MainId = Unit.JuridicalId
                                               AND JuridicalKey.ValueId = Movement.FromId
        JOIN MovementItem_OrderExternal_View AS MovementItem  
                                             ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased   = false
       WHERE Movement.Id = inMovementId;

     RETURN NEXT Cursor2;
     RETURN;

     END IF;

   IF vbJuridicalId = 59610 THEN --БАДМ
     OPEN Cursor1 FOR
       SELECT ''::TVarChar AS FieldName, ''::TVarChar AS DisplayName;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
       SELECT            
             MovementItem.PartnerGoodsCode::TVarChar as CODE
           , MovementItem.Amount                     as CNT
           
        FROM MovementItem_OrderExternal_View AS MovementItem
       WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = false;

     RETURN NEXT Cursor2;
     RETURN;
   END IF;

    IF vbJuridicalId = 59612  --Вента
    THEN
        OPEN Cursor1 FOR
            SELECT 
                'PartnerCode'::TVarChar AS FieldName, 
                'Код пост-ка Item ID'::TVarChar AS DisplayName, 
                130 AS Width
            UNION
            SELECT 
                'Code'::TVarChar AS FieldName, 
                'Код Клиента'::TVarChar AS DisplayName, 
                100 AS Width
            UNION 
            SELECT 
                'GoodsName'::TVarChar AS FieldName, 
                'Товар'::TVarChar AS DisplayName, 
                200 AS Width
            UNION 
            SELECT 
                'Amount'::TVarChar AS FieldName, 
                'Кол-во'::TVarChar AS DisplayName, 
                100 AS Width
            UNION 
            SELECT 
                'Price'::TVarChar AS FieldName, 
                'Цена без ндс'::TVarChar AS DisplayName, 
                100 AS Width
            UNION 
            SELECT 
                'Summ'::TVarChar AS FieldName, 
                'Cумма без ндс'::TVarChar AS DisplayName, 
                100 AS Width
            UNION 
            SELECT 
                'PartionGoodsDate'::TVarChar AS FieldName, 
                'Cрок годности'::TVarChar AS DisplayName, 
                100 AS Width
            -- UNION 
            -- SELECT 
                -- 'CommonCode'::TVarChar AS FieldName, 
                -- 'Код Мориона'::TVarChar AS DisplayName, 
                -- 100 AS Width
                ;

        RETURN NEXT Cursor1;

        OPEN Cursor2 FOR
            SELECT            
                MovementItem.PartnerGoodsCode::TVarChar AS PartnerCode
              , MovementItem.GoodsCode::TVarChar        AS Code
              , MovementItem.GoodsName                  AS GoodsName
              , MovementItem.Amount                     AS Amount
              , MovementItem.Price
              , MovementItem.Summ
              , MovementItem.PartionGoodsDate
--              , MAX(Object_LinkGoods_View.GoodsCodeInt)      AS CommonCode
            FROM 
                MovementItem_OrderExternal_View AS MovementItem
                -- LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                     -- ON ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                                    -- AND ObjectLink_LinkGoods_Goods.ChildObjectId = MovementItem.GoodsId
                -- LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                     -- ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                    -- AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                -- LEFT JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsMainId = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
                                               -- AND Object_LinkGoods_View.ObjectId = zc_Enum_GlobalConst_Marion()
            WHERE 
                MovementItem.MovementId = inMovementId 
                AND 
                MovementItem.isErased = FALSE
            -- GROUP BY
                -- MovementItem.PartnerGoodsCode
              -- , MovementItem.GoodsCode
              -- , MovementItem.GoodsName
              -- , MovementItem.Amount
              -- , MovementItem.Price
              -- , MovementItem.Summ
              -- , MovementItem.PartionGoodsDate
              ;
        RETURN NEXT Cursor2;
        RETURN;
    END IF;


   IF vbJuridicalId = 183317 THEN --- Дельта Медикел
     OPEN Cursor1 FOR
       SELECT 'PartnerCode'::TVarChar AS FieldName, 'Код покупателя'::TVarChar AS DisplayName, 100 AS Width
 UNION SELECT 'Code'::TVarChar AS FieldName, 'Код'::TVarChar AS DisplayName, 100 AS Width
 UNION SELECT 'GoodsName'::TVarChar AS FieldName, 'Товар'::TVarChar AS DisplayName, 200 AS Width
 UNION SELECT 'Amount'::TVarChar AS FieldName, 'Кол-во'::TVarChar AS DisplayName, 100 AS Width
 UNION SELECT 'Price'::TVarChar AS FieldName, 'Цена без ндс'::TVarChar AS DisplayName, 100 AS Width
 UNION SELECT 'Summ'::TVarChar AS FieldName, 'Cумма без ндс'::TVarChar AS DisplayName, 100 AS Width
 UNION SELECT 'PartionGoodsDate'::TVarChar AS FieldName, 'Cрок годности'::TVarChar AS DisplayName, 100 AS Width
 UNION SELECT 'OKPO'::TVarChar AS FieldName, 'ОКПО'::TVarChar AS DisplayName, 100 AS Width
 UNION SELECT 'UnitCode'::TVarChar AS FieldName, 'Код аптеки'::TVarChar AS DisplayName, 100 AS Width
 ;
     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
       SELECT            
             MovementItem.PartnerGoodsCode::TVarChar AS PartnerCode
           , MovementItem.GoodsCode::TVarChar        AS Code
           , MovementItem.GoodsName                  AS GoodsName
           , MovementItem.Amount                     AS Amount
           , MovementItem.Price
           , MovementItem.Summ
           , MovementItem.PartionGoodsDate
           , vbOKPO                                  AS OKPO
           , vbUnitCode                              AS UnitCode
       FROM MovementItem_OrderExternal_View AS MovementItem
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.isErased = false;

     RETURN NEXT Cursor2;
     RETURN;
   END IF;
   
   
   -- Во всех других случаях
     OPEN Cursor1 FOR
       SELECT 'PartnerCode'::TVarChar AS FieldName, 'Код покупателя'::TVarChar AS DisplayName, 100 AS Width
 UNION SELECT 'Code'::TVarChar AS FieldName, 'Код'::TVarChar AS DisplayName, 100 AS Width
 UNION SELECT 'GoodsName'::TVarChar AS FieldName, 'Товар'::TVarChar AS DisplayName, 200 AS Width
 UNION SELECT 'Amount'::TVarChar AS FieldName, 'Кол-во'::TVarChar AS DisplayName, 100 AS Width
 UNION SELECT 'Price'::TVarChar AS FieldName, 'Цена без ндс'::TVarChar AS DisplayName, 100 AS Width
 UNION SELECT 'Summ'::TVarChar AS FieldName, 'Cумма без ндс'::TVarChar AS DisplayName, 100 AS Width
 UNION SELECT 'PartionGoodsDate'::TVarChar AS FieldName, 'Cрок годности'::TVarChar AS DisplayName, 100 AS Width;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
       SELECT            
             MovementItem.PartnerGoodsCode::TVarChar as PartnerCode
           , MovementItem.GoodsCode::TVarChar        as Code
           , MovementItem.GoodsName                  AS GoodsName
           , MovementItem.Amount                     as Amount
           , MovementItem.Price
           , MovementItem.Summ
           , MovementItem.PartionGoodsDate

        FROM MovementItem_OrderExternal_View AS MovementItem
       WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = false;
     RETURN NEXT Cursor2;

   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderExternal_Export (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.06.15                         *
 13.01.15                         *
 25.12.14                         *
 12.12.14                         *
 06.11.14                         *
 20.10.14                         *
 15.07.14                                                       *
 01.07.14                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- select * from gpSelect_MovementItem_OrderExternal_Export(inMovementId := 80 ,  inSession := '3');
                     