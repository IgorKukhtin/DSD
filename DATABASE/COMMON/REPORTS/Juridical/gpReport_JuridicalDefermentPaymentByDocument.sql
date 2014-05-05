-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentPaymentByDocument (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentPaymentByDocument(
    IN inOperDate         TDateTime , -- 
    IN inContractDate     TDateTime , -- 
    IN inJuridicalId      Integer   ,
    IN inAccountId        Integer   , --
    IN inContractId       Integer   , --
    IN inPaidKindId       Integer   , --
    IN inPeriodCount      Integer   , --
    IN inSumm             TFloat    , 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, OperDate TDateTime, InvNumber TVarChar, TotalSumm TFloat, FromName TVarChar, ToName TVarChar, ContractNumber TVarChar, ContractTagName TVarChar, PaidKindName TVarChar)
AS
$BODY$
   DECLARE vbLenght Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbNextOperDate TDateTime;
   DECLARE vbOperSumm TFloat;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

     -- Выбираем остаток на дату по юр. лицам в разрезе договоров. 
     -- Так же выбираем продажи и возвраты за период 
  vbLenght := 7;

  -- !!!Отчет строим не по договору а по "ключу"!!!
  CREATE TEMP TABLE _tmpContract (ContractId Integer) ON COMMIT DROP; 
  INSERT INTO _tmpContract (ContractId)
      SELECT COALESCE (View_Contract_ContractKey_find.ContractId, View_Contract_ContractKey.ContractId) AS ContractId
      FROM Object_Contract_ContractKey_View AS View_Contract_ContractKey
           LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey_find ON View_Contract_ContractKey_find.ContractKeyId = View_Contract_ContractKey.ContractKeyId
      WHERE View_Contract_ContractKey.ContractId = inContractId;


  IF inPeriodCount < 5 THEN

    RETURN QUERY  
        SELECT 
              Movement.Id
            , Movement.OperDate
            , Movement.InvNumber
            , MovementFloat_TotalSumm.ValueData  AS TotalSumm
            , Object_From.ValueData AS FromName
            , Object_To.ValueData   AS ToName
            , View_Contract_InvNumber.InvNumber AS ContractNumber
            , View_Contract_InvNumber.ContractTagName
            , Object_PaidKind.ValueData  AS PaidKindName
         FROM Movement 
              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
              LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
              INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

              INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                            ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                           AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
              LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

              LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                          AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
              -- !!!Группируем Договора!!!
              LEFT JOIN _tmpContract ON _tmpContract.ContractId = MovementLinkObject_Contract.ObjectId
              LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
              LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                      ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        WHERE Movement.DescId = zc_Movement_Sale()
          AND Movement.StatusId = zc_enum_status_complete()
          AND (_tmpContract.ContractId > 0 OR inContractId = 0)
          AND (MovementLinkObject_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)
          AND Movement.OperDate >= (inContractDate::date - vbLenght * inPeriodCount)
          AND Movement.OperDate < (inContractDate::date - vbLenght * (inPeriodCount - 1))
          AND ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId
    ORDER BY OperDate;
    
    ELSE
      vbOperDate := (inContractDate::DATE) - vbLenght * 4;
      vbNextOperDate := vbOperDate;
      vbOperSumm := 0;
      
      CREATE TEMP TABLE _tempMovement(Id Integer, Summ TFloat) ON COMMIT DROP; 
      
      WHILE (vbOperSumm < inSumm) AND NOT (vbNextOperDate IS NULL) LOOP
      	SELECT MAX (Movement.OperDate) INTO vbNextOperDate
      	  FROM Movement 
              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
              INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
              INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                            ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                           AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

              LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                          AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
              -- !!!Группируем Договора!!!
              LEFT JOIN _tmpContract ON _tmpContract.ContractId = MovementLinkObject_Contract.ObjectId

      	 WHERE Movement.OperDate < vbOperDate  AND Movement.DescId = zc_Movement_sale() AND StatusId = zc_enum_status_complete()
           AND (_tmpContract.ContractId > 0 OR inContractId = 0)
           AND (MovementLinkObject_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)
      	   AND ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId;
      	 
     -- 	raise EXCEPTION 'vbNextOperDate %, % ', vbNextOperDate, vbOperDate   	 ;
      	 
         --
      	 IF NOT (vbNextOperDate IS NULL)
         THEN
              INSERT INTO _tempMovement (Id, Summ)
      	        SELECT Movement.Id, MovementFloat_TotalSumm.ValueData
      	        FROM Movement 
                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                     INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                   ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                  AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                     -- !!!Группируем Договора!!!
                     LEFT JOIN _tmpContract ON _tmpContract.ContractId = MovementLinkObject_Contract.ObjectId

                     LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                             ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                            AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                WHERE Movement.OperDate < vbOperDate AND Movement.OperDate >= vbNextOperDate AND Movement.DescId = zc_Movement_sale() 
                  AND (_tmpContract.ContractId > 0 OR inContractId = 0)
                  AND (MovementLinkObject_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)
                  AND Movement.StatusId = zc_enum_status_complete() AND ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId;


      	    vbOperDate := vbNextOperDate;
      	    
      	 END IF;
         SELECT COALESCE(SUM(Summ), 0) INTO vbOperSumm 
           FROM _tempMovement;
      END LOOP;


     RETURN  QUERY  
        SELECT
              Movement.Id
            , Movement.OperDate
            , Movement.InvNumber
            , MovementFloat_TotalSumm.ValueData  AS TotalSumm
            , Object_From.ValueData AS FromName
            , Object_To.ValueData   AS ToName
            , View_Contract_InvNumber.InvNumber AS ContractNumber
            , View_Contract_InvNumber.ContractTagName
            , Object_PaidKind.ValueData  AS PaidKindName
        FROM Movement 
             INNER JOIN _tempMovement ON _tempMovement.Id = Movement.Id
             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
             LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                          ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                         AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
        ORDER BY Movement.OperDate;
         
    END IF;
          
          --, zc_Movement_ReturnIn()) 
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalDefermentPaymentByDocument (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.05.14                                        * add inPaidKindId
 26.04.14                                        * add Object_Contract_ContractKey_View
 01.04.14                          * 
 27.03.14                          * 
 21.02.14                          * 
*/

-- тест
-- SELECT * FROM gpReport_JuridicalDefermentPaymentByDocument ('01.01.2014'::TDateTime, '01.02.2013'::TDateTime, 0, 0, 0, 0, 0, 0, inSession:= '2' :: TVarChar); 
