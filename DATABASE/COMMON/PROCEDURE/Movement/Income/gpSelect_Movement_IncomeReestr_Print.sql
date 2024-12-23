-- Function: gpSelect_Movement_IncomeReestr_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_IncomeReestr_Print (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_IncomeReestr_Print(
    IN inStartDate         TDateTime , -- Дата нач. периода
    IN inEndDate           TDateTime , -- Дата оконч. периода
    IN inUnitId            Integer  , -- ключ склад
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    --DECLARE Cursor2 refcursor;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income_Print());
     vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inUnitId,0) = 0
    THEN 
        RAISE EXCEPTION 'Ошибка.Не отпраделено подразделение.';
    END IF;
        
    --склад минус+охлажденка Дільниця обліку і реалізації м`ясної сировини, группа           --  8445        8444    133049     
    IF COALESCE (inUnitId,0) IN (8444, 8445, 133049)
    THEN
        inUnitId := 8443 ;     --Склад минус+охлажд.
    END IF;
    
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    INSERT INTO _tmpUnit (UnitId)
      SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect
    ;


      --
    OPEN Cursor1 FOR
    WITH 
    tmpMovement AS (SELECT Movement.Id
                         , Movement.OperDate
                         , Movement.InvNumber
                         , MovementLinkObject_To.ObjectId AS ToId
                    FROM Movement
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_To.ObjectId                      
                    WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                      AND Movement.DescId = zc_Movement_Income()
                      AND Movement.StatusId = zc_Enum_Status_Complete()
                    )
  
  , tmpMovementFloat AS (SELECT MovementFloat.*
                         FROM MovementFloat
                         WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                           AND MovementFloat.DescId IN (zc_MovementFloat_TotalCount()
                                                      , zc_MovementFloat_TotalCountPartner()
                                                      , zc_MovementFloat_TotalCountKg()
                                                      , zc_MovementFloat_TotalSummPVAT()    --Итого сумма по документу (с НДС)
                                                      , zc_MovementFloat_TotalSumm()     	--Итого сумма по документу (с учетом НДС и скидки)
                                                      )
                         )

  , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                           FROM MovementLinkObject
                           WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                             AND MovementLinkObject.DescId IN (zc_MovementLinkObject_From()
                                                             , zc_MovementLinkObject_PaidKind()
                                                             )
                         )

         SELECT
             Movement.Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , Movement.InvNumber
           , Movement.OperDate
           , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

           , MovementFloat_TotalCount.ValueData          AS TotalCount
           , MovementFloat_TotalCountPartner.ValueData   AS TotalCountPartner
           , MovementFloat_TotalCountKg.ValueData        AS TotalCountKg
           , MovementFloat_TotalSummPVAT.ValueData       AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData           AS TotalSumm

           , Object_From.ValueData             AS FromName
           , Object_To.ValueData               AS ToName
           , Object_PaidKind.ValueData         AS PaidKindName

       FROM tmpMovement AS Movement
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                       ON MovementFloat_TotalCount.MovementId = Movement.Id
                                      AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountPartner
                                       ON MovementFloat_TotalCountPartner.MovementId = Movement.Id
                                      AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                       ON MovementFloat_TotalCountKg.MovementId = Movement.Id
                                      AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                       ON MovementFloat_TotalSummPVAT.MovementId = Movement.Id
                                      AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                       ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_From
                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN Object AS Object_To ON Object_To.Id = Movement.ToId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PaidKind
                                            ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                           AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
      ;
     
    RETURN NEXT Cursor1;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.20         *
 05.06.15         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_IncomeReestr_Print (inStartDate := '01.12.2024', inEndDate:= '02.12.2024', inUnitId:=0, inSession:= '5'); -- FETCH ALL "<unnamed portal 10>";
--select * from gpSelect_Movement_IncomeReestr_Print(inStartDate := ('01.11.2024')::TDateTime , inEndDate := ('07.11.2024')::TDateTime , inUnitId := 8445 ,  inSession := '9457'); FETCH ALL "<unnamed portal 7>";
