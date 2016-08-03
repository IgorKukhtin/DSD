-- Function: gpSelect_Movement_OrderInternal()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inUnitId        Integer,  --Подразделение
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer
             , TotalCount TFloat, TotalSumm TFloat, TotalSummChangePercent TFloat
             , UnitName TVarChar, CashRegisterName TVarChar, PaidTypeName TVarChar
             , CashMember TVarChar, Bayer TVarChar, FiscalCheckNumber TVarChar, NotMCS Boolean, IsDeferred Boolean
             , DiscountCardName TVarChar, DiscountCard_ObjectName TVarChar
             , BayerPhone TVarChar
             , InvNumberOrder TVarChar
             , ConfirmedKindName TVarChar
)

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbReteilId Integer;   
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     -- определяем Торговую сеть входящего подразделения
     vbReteilId:= CASE WHEN vbUserId = 3
                  THEN vbObjectId
                  ELSE
                  (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                            ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                   )
                   END;

     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )

         SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Movement_Check.StatusCode
           , Movement_Check.TotalCount
           , Movement_Check.TotalSumm
           , Movement_Check.TotalSummChangePercent
           , Movement_Check.UnitName
           , Movement_Check.CashRegisterName
           , Movement_Check.PaidTypeName
           , Movement_Check.CashMember
           , Movement_Check.Bayer
           , Movement_Check.FiscalCheckNumber
           , Movement_Check.NotMCS
           , Movement_Check.IsDeferred
           , Movement_Check.DiscountCardName
           , Object_Object.ValueData   AS DiscountCard_ObjectName
           , Movement_Check.BayerPhone
           , Movement_Check.InvNumberOrder
           , Movement_Check.ConfirmedKindName
        FROM Movement_Check_View AS Movement_Check 
             JOIN tmpStatus ON tmpStatus.StatusId = Movement_Check.StatusId
             LEFT JOIN ObjectLink AS ObjectLink_Object
                                  ON ObjectLink_Object.ObjectId = Movement_Check.DiscountCardId
                                 AND ObjectLink_Object.DescId = zc_ObjectLink_DiscountCard_Object()
             LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId
                           
       WHERE Movement_Check.OperDate >= DATE_TRUNC ('DAY', inStartDate) AND Movement_Check.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
         AND (Movement_Check.UnitId = inUnitId)
         AND (vbReteilId = vbObjectId)
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 21.07.16         *
 05.05.16         *
 07.08.15                                                                        *
 08.05.15                         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Check (inStartDate:= '01.08.2016', inEndDate:= '01.08.2016', inIsErased := FALSE, inUnitId:= 1, inSession:= '2')
