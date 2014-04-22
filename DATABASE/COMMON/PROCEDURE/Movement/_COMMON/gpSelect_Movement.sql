-- Function: gpSelect_Movement_Send()

DROP FUNCTION IF EXISTS gpSelect_Movement (TDateTime, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement (TDateTime, TDateTime, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inJuridicalId INTEGER   , 
    IN inContractId  Integer   , 
    IN inDescSet     TVarChar  ,  
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, DescId Integer, DescName TVarChar
             , TotalSumm TFloat
             , JuridicalId Integer, JuridicalName TVarChar)
AS
$BODY$
   DECLARE vbDescId integer; 
           vbIndex  Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());

     -- таблица - MovementDesc
     CREATE TEMP TABLE _tmpMovementDesc (DescId Integer) ON COMMIT DROP;
     vbIndex := 1;

     WHILE split_part(inDescSet, ';', vbIndex) <> '' LOOP

         EXECUTE 'SELECT '||split_part(inDescSet, ';', vbIndex) INTO vbDescId;
         INSERT INTO _tmpMovementDesc SELECT vbDescId;
         vbIndex := vbIndex + 1;

     END LOOP;


     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Movement.DescId
           , MovementDesc.ItemName  
           , COALESCE(MovementFloat_TotalSumm.ValueData, MovementItem.Amount)  AS TotalSumm

           , COALESCE(Object_MoneyPlace.Id, PlaceFrom.Id, PlaceTo.Id)           AS JuridicalId
           , COALESCE(Object_MoneyPlace.ValueData, PlaceFrom.ValueData, PlaceTo.ValueData)           AS JuridicalName
             
       FROM Movement
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_JuridicalTo
                                 ON ObjectLink_Partner_JuridicalTo.ObjectId = MovementLinkObject_To.ObjectId 
                                AND ObjectLink_Partner_JuridicalTo.DescId = zc_ObjectLink_Partner_Juridical()


            LEFT JOIN Object AS PlaceTo ON PlaceTo.Id = COALESCE(ObjectLink_Partner_JuridicalTo.ChildObjectId, MovementLinkObject_To.ObjectId)
                                       AND PlaceTo.DescId = zc_Object_Juridical()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_JuridicalFrom
                                 ON ObjectLink_Partner_JuridicalFrom.ObjectId = MovementLinkObject_From.ObjectId 
                                AND ObjectLink_Partner_JuridicalFrom.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_JuridicalFrom
                                 ON ObjectLink_CardFuel_JuridicalFrom.ObjectId = MovementLinkObject_From.ObjectId 
                                AND ObjectLink_CardFuel_JuridicalFrom.DescId = zc_ObjectLink_CardFuel_Juridical()

            LEFT JOIN Object AS PlaceFrom ON PlaceFrom.Id = COALESCE(ObjectLink_Partner_JuridicalFrom.ChildObjectId, MovementLinkObject_From.ObjectId, ObjectLink_CardFuel_JuridicalFrom.ChildObjectId)
                                         AND PlaceFrom.DescId = zc_Object_Juridical() 

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() 
                                  AND Movement.DescId IN (zc_Movement_Cash(), zc_Movement_BankAccount()
                                                        , zc_Movement_ProfitLossService(), zc_Movement_Service()
                                                        , zc_Movement_SendDebt(), zc_Movement_LossDebt())

            LEFT JOIN MovementItem AS MI_Child ON MI_Child.MovementId = Movement.Id AND MI_Child.DescId = zc_MI_Child() 
                                  AND Movement.DescId IN (zc_Movement_SendDebt())

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                         ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                        AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()

            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                         ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                
       WHERE Movement.statusid = zc_enum_status_complete() AND  Movement.DescId IN (SELECT _tmpMovementDesc.DescId FROM _tmpMovementDesc) AND Movement.OperDate BETWEEN inStartDate AND inEndDate 
         AND (COALESCE(ObjectLink_Partner_JuridicalTo.ChildObjectId, MovementLinkObject_To.ObjectId) = inJuridicalId 
                 OR COALESCE(ObjectLink_Partner_JuridicalFrom.ChildObjectId, MovementLinkObject_From.ObjectId) = inJuridicalId 
                 OR MILinkObject_MoneyPlace.ObjectId = inJuridicalId
                 OR MovementItem.ObjectId = inJuridicalId
                 OR MI_Child.ObjectId = inJuridicalId
                 OR inJuridicalId = 0)
         AND (MILinkObject_Contract.ObjectId = inContractId 
           OR MovementLinkObject_Contract.ObjectId = inContractId 
           OR inContractId = 0)
                 ;
  
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement (TDateTime, TDateTime, Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.04.14                         *
 11.03.14                         *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_Send (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')