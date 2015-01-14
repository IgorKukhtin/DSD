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
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderExternal());
     vbUserId := inSession;

   SELECT FromId INTO vbJuridicalId
       FROM Movement_OrderExternal_View 
       WHERE Movement_OrderExternal_View.Id = inMovementId;




     IF vbJuridicalId = 59611 THEN --Оптима


     OPEN Cursor1 FOR
       SELECT ''::TVarChar AS FieldName, ''::TVarChar AS DisplayName;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
       SELECT            
--             JuridicalKey.IntegerKey as CodeDebet
--           , PointKey.IntegerKey     as CodePoint
             ''::VarChar(10)                        AS Field1
           , ''::VarChar(10)                        AS Field2
           , ''::VarChar(10)                        AS Field3
           , MovementItem.Amount                    as ZAKAZ
           , ''::VarChar(10)                        AS Field4
           , ''::VarChar(10)                        AS Field5
           , ''::VarChar(10)                        AS Field6
           , MovementItem.PartnerGoodsCode::Integer as KOD
           
        FROM Movement_OrderExternal_View AS Movement
         LEFT JOIN Object_ImportExportLink_View AS PointKey ON PointKey.LinkTypeId = zc_Enum_ImportExportLinkType_UnitJuridical()
                                               AND PointKey.MainId = Movement.ToId
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
   -- Во всех других случаях
     OPEN Cursor1 FOR
       SELECT 'Code'::TVarChar AS FieldName, 'Код'::TVarChar AS DisplayName
 UNION SELECT 'Amount'::TVarChar AS FieldName, 'Количество'::TVarChar AS DisplayName;
                                          
     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
       SELECT            
             MovementItem.PartnerGoodsCode::TVarChar as Code
           , MovementItem.Amount                     as Amount
           
        FROM MovementItem_OrderExternal_View AS MovementItem
       WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = false;

   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderExternal_Export (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
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
                     