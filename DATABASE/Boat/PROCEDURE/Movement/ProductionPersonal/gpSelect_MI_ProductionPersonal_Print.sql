-- Function: gpSelect_MI_ProductionPersonal_Print()

DROP FUNCTION IF EXISTS gpSelect_MI_ProductionPersonal_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionPersonal_Print(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Check());
    vbUserId:= inSession;

OPEN Cursor1 FOR

        SELECT 
            Movement_ProductionPersonal.Id
          , Movement_ProductionPersonal.InvNumber
          , Movement_ProductionPersonal.OperDate        AS OperDate

          , Object_Unit.Id                              AS UnitId      
          , Object_Unit.ValueData                       AS UnitName
          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment

        FROM Movement AS Movement_ProductionPersonal 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement_ProductionPersonal.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId 

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_ProductionPersonal.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

        WHERE Movement_ProductionPersonal.Id = inMovementId
          AND Movement_ProductionPersonal.DescId = zc_Movement_ProductionPersonal();

    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
       WITH
       tmpMI AS (SELECT MovementItem.ObjectId
                      , MovementItem.Amount
                      , MovementItem.Id
                      , MovementItem.isErased
                 FROM MovementItem 
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                  )

      -- результат   показываем ш/к сотрудника + фио +  + + + + 
      SELECT
          MovementItem.Id             AS Id
        , MovementItem.ObjectId       AS PersonalId
        , Object_Personal.ObjectCode  AS PersonalCode
        , Object_Personal.ValueData   AS PersonalName

        , Object_Product.Id           AS ProductId
        , Object_Product.ObjectCode   AS ProductCode
        , Object_Product.ValueData    AS ProductName
        , ObjectString_CIN.ValueData  AS CIN

        , MovementItem.Amount           ::TFloat
        
        , MIDate_StartBegin.ValueData AS StartBeginDate
        , MIDate_EndBegin.ValueData   AS EndBeginDate

        , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumber_OrderClient_full
        , Movement_OrderClient.OperDate          AS OperDate_OrderClient
        , Movement_OrderClient.InvNumber         AS InvNumber_OrderClient
        , Object_From_OrderClient.ValueData      AS FromName_OrderClient
          
        , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement_OrderClient.Id) AS BarCode_OrderClient
        , zfFormat_BarCode (zc_BarCodePref_Object(), Object_Product.Id)         AS BarCode_Product
        , zfFormat_BarCode (zc_BarCodePref_Object(), Object_Personal.Id)        AS BarCode_Personal

      FROM tmpMI AS MovementItem
           LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementItem.ObjectId

           LEFT JOIN MovementItemLinkObject AS MILO_Product
                                            ON MILO_Product.MovementItemId = MovementItem.Id
                                           AND MILO_Product.DescId = zc_MILinkObject_Product()
           LEFT JOIN Object AS Object_Product ON Object_Product.Id = MILO_Product.ObjectId

           LEFT JOIN MovementItemDate AS MIDate_StartBegin
                                      ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                     AND MIDate_StartBegin.DescId = zc_MIDate_StartBegin()
           LEFT JOIN MovementItemDate AS MIDate_EndBegin
                                      ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                     AND MIDate_EndBegin.DescId = zc_MIDate_EndBegin()

           LEFT JOIN ObjectString AS ObjectString_CIN
                                  ON ObjectString_CIN.ObjectId = Object_Product.Id
                                 AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

           LEFT JOIN MovementLinkObject AS MovementLinkObject_Product 
                                        ON MovementLinkObject_Product.ObjectId = Object_Product.Id
                                       AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
           LEFT JOIN Movement AS Movement_OrderClient
                              ON Movement_OrderClient.Id = MovementLinkObject_Product.MovementId
                             AND Movement_OrderClient.DescId = zc_Movement_OrderClient()

           LEFT JOIN MovementLinkObject AS MovementLinkObject_From_OrderClient
                                        ON MovementLinkObject_From_OrderClient.MovementId = Movement_OrderClient.Id
                                       AND MovementLinkObject_From_OrderClient.DescId = zc_MovementLinkObject_From()
           LEFT JOIN Object AS Object_From_OrderClient ON Object_From_OrderClient.Id = MovementLinkObject_From_OrderClient.ObjectId
      ORDER BY Object_Product.Id
             , MovementItem.ObjectId
             , MIDate_StartBegin.ValueData
            ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.07.21         *
*/
-- тест
--select * from gpSelect_Movement_ProductionPersonal_Print(inMovementId := 3897397 ,  inSession := '3');
