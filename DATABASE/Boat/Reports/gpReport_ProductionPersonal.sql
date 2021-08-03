-- Function: gpReport_ProductionPersonal)

DROP FUNCTION IF EXISTS gpReport_ProductionPersonal (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProductionPersonal (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inProductId    Integer   ,
    IN inPersonalId   Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (  
                MovementId Integer
              , OperDate TDateTime
              , InvNumber TVarChar
              , StatusCode Integer
              , UnitId Integer
              , UnitCode Integer
              , UnitName TVarChar
              , PersonalId Integer
              , PersonalCode Integer
              , PersonalName TVarChar
              , ProductId Integer
              , ProductCode Integer
              , ProductName TVarChar
              , CIN TVarChar
              , Amount TFloat
              , StartBeginDate TDateTime
              , EndBeginDate TDateTime
              , BarCode_OrderClient TVarChar
              , BarCode_Product TVarChar
              , BarCode_Personal TVarChar

              , InvNumber_OrderClient_full TVarChar
              , OperDate_OrderClient TDateTime
              , InvNumber_OrderClient TVarChar
              , FromName_OrderClient TVarChar
)
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_ProductionPersonal());
     vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
           
    WITH
    --выбираем документы за период + выбор лодки (в этом случае нет ограничения периодом, т.е. показываем все работы) + фио 
    tmpMovement AS (SELECT Movement.*
                         , MILO_Product.ObjectId AS ProductId
                         , MovementItem.ObjectId AS PersonalId
                         , MovementItem.Amount   AS Amount
                         , MovementItem.Id       AS MI_Id
                    FROM Movement
                         JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.isErased   = FALSE
                                          AND MovementItem.Amount <> 0
                                          AND (MovementItem.ObjectId = inPersonalId OR inPersonalId = 0)
                         LEFT JOIN MovementItemLinkObject AS MILO_Product
                                                          ON MILO_Product.MovementItemId = MovementItem.Id
                                                         AND MILO_Product.DescId = zc_MILinkObject_Product()
                         LEFT JOIN Object AS Object_Product ON Object_Product.Id = MILO_Product.ObjectId
                    WHERE Movement.DescId = zc_Movement_ProductionPersonal()
                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                      AND (Movement.OperDate BETWEEN inStartDate AND inEndDate OR inProductId <> 0)
                      AND (MILO_Product.ObjectId = inProductId OR inProductId = 0)
                    )

  , tmpMILO_Unit AS (SELECT MovementLinkObject.*
                     FROM MovementLinkObject
                     WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit()
                    )

  , tmpMIDate AS (SELECT MovementItemDate.*
                  FROM MovementItemDate
                  WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMovement.MI_Id FROM tmpMovement)
                    AND MovementItemDate.DescId IN (zc_MIDate_StartBegin()
                                                  , zc_MIDate_EndBegin())
                 )


      -- Результат
      SELECT tmpMovement.Id              AS MovementId
           , tmpMovement.OperDate        AS OperDate
           , tmpMovement.InvNumber       AS InvNumber
           , Object_Status.ObjectCode    AS StatusCode
           , Object_Unit.Id              AS UnitId
           , Object_Unit.ObjectCode      AS UnitCode
           , Object_Unit.ValueData       AS UnitName

           , Object_Personal.Id          AS PersonalId
           , Object_Personal.ObjectCode  AS PersonalCode
           , Object_Personal.ValueData   AS PersonalName

           , Object_Product.Id           AS ProductId
           , Object_Product.ObjectCode   AS ProductCode
           , Object_Product.ValueData    AS ProductName
           , ObjectString_CIN.ValueData  AS CIN

           , tmpMovement.Amount          AS Amount
           , MIDate_StartBegin.ValueData AS StartBeginDate
           , MIDate_EndBegin.ValueData   AS EndBeginDate

           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement_OrderClient.Id) AS BarCode_OrderClient
           , zfFormat_BarCode (zc_BarCodePref_Object(), Object_Product.Id)         AS BarCode_Product
           , zfFormat_BarCode (zc_BarCodePref_Object(), Object_Personal.Id)        AS BarCode_Personal

           , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumber_OrderClient_full
           , Movement_OrderClient.OperDate          AS OperDate_OrderClient
           , Movement_OrderClient.InvNumber         AS InvNumber_OrderClient
           , Object_From_OrderClient.ValueData      AS FromName_OrderClient
      FROM tmpMovement
           LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpMovement.StatusId

           LEFT JOIN tmpMILO_Unit AS MovementLinkObject_Unit
                                  ON MovementLinkObject_Unit.MovementId = tmpMovement.Id
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

           LEFT JOIN tmpMIDate AS MIDate_StartBegin
                               ON MIDate_StartBegin.MovementItemId = tmpMovement.MI_Id
                              AND MIDate_StartBegin.DescId = zc_MIDate_StartBegin()
           LEFT JOIN tmpMIDate AS MIDate_EndBegin
                               ON MIDate_EndBegin.MovementItemId = tmpMovement.MI_Id
                              AND MIDate_EndBegin.DescId = zc_MIDate_EndBegin()
                                                                         
           LEFT JOIN Object AS Object_Product ON Object_Product.Id   = tmpMovement.ProductId
           LEFT JOIN Object AS Object_Personal ON Object_Personal.Id   = tmpMovement.PersonalId
           
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
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.08.21         *
*/

-- тест
-- select * from gpReport_ProductionPersonal(inStartDate := ('01.01.2020')::TDateTime , inEndDate := ('03.05.2022')::TDateTime , inProductId := 0 , inPersonalId := 40018, inSession := '5');