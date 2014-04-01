-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentPaymentByDocument (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentPaymentByDocument (TDateTime, TDateTime, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentPaymentByDocument (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentPaymentByDocument(
    IN inOperDate         TDateTime , -- 
    IN inContractDate     TDateTime , -- 
    IN inJuridicalId      INTEGER   ,
    IN inAccountId        Integer   , --
    IN inContractId       Integer   , --
    IN inPeriodCount      Integer   , --
    IN inSumm             TFloat    , 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, OperDate TDateTime, InvNumber TVarChar, TotalSumm TFloat, FromName TVarChar, ToName TVarChar)
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

  IF inPeriodCount < 5 THEN

    RETURN QUERY  
        SELECT 
              Movement.Id
            , Movement.OperDate
            , Movement.InvNumber
            , MovementFloat_TotalSumm.ValueData  AS TotalSumm
            , Object_From.ValueData AS FromName
            , Object_To.ValueData   AS ToName
         FROM Movement 
              JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
              JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
              JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                 ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                     AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             LEFT JOIN Object AS Object_From 
                   ON Object_From.Id = MovementLinkObject_From.ObjectId
             LEFT JOIN Object AS Object_To
                    ON Object_To.Id = MovementLinkObject_To.ObjectId
        WHERE Movement.DescId = zc_Movement_Sale()
          AND Movement.StatusId = zc_enum_status_complete()
          AND (MovementLinkObject_Contract.ObjectId = inContractId OR inContractId = 0)
          AND Movement.OperDate >= (inContractDate::date - vbLenght * inPeriodCount) 
          AND Movement.OperDate < (inContractDate::date - vbLenght * (inPeriodCount - 1))
          AND ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId 
    ORDER BY OperDate;
    
    ELSE
      vbOperDate := (inContractDate::DATE) - vbLenght * 4;
      vbNextOperDate := vbOperDate;
      vbOperSumm := 0;
      
      CREATE TEMP TABLE _tempMovement(Id INTEGER, Summ TFloat) ON COMMIT DROP; 
      
      WHILE (vbOperSumm < inSumm) AND NOT (vbNextOperDate IS NULL) LOOP
      	SELECT max(movement.OperDate) INTO vbNextOperDate 
      	  FROM movement 
              JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
              JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                     AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
      	 WHERE movement.OperDate < vbOperDate  AND movement.DescId = zc_movement_sale() AND StatusId = zc_enum_status_complete()
           AND (MovementLinkObject_Contract.ObjectId = inContractId OR inContractId = 0)
      	   AND ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId;
      	 
     -- 	raise EXCEPTION 'vbNextOperDate %, % ', vbNextOperDate, vbOperDate   	 ;
      	 
      	 IF NOT (vbNextOperDate IS NULL) THEN
      	    
      	    INSERT INTO _tempMovement(Id, Summ)
      	      SELECT Movement.Id, MovementFloat_TotalSumm.ValueData
      	        FROM Movement 
           LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                   ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                  AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
               LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                     AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
      	      WHERE Movement.OperDate < vbOperDate AND Movement.OperDate >= vbNextOperDate AND Movement.DescId = zc_movement_sale() 
                AND (MovementLinkObject_Contract.ObjectId = inContractId OR inContractId = 0)
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
         FROM Movement 
              JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
              JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
              JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                 ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
             LEFT JOIN Object AS Object_From 
                   ON Object_From.Id = MovementLinkObject_From.ObjectId
             LEFT JOIN Object AS Object_To
                    ON Object_To.Id = MovementLinkObject_To.ObjectId
             JOIN _tempMovement ON _tempMovement.Id = Movement.Id
    ORDER BY Movement.OperDate;
         
    END IF;
          
          --, zc_Movement_ReturnIn()) 
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalDefermentPaymentByDocument (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TFloat, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.04.14                          * 
 27.03.14                          * 
 21.02.14                          * 
*/

-- тест
-- SELECT * FROM gpReport_JuridicalDefermentPayment ('01.01.2014'::TDateTime, '01.02.2013'::TDateTime, 0, inSession:= '2'::TVarChar); 
