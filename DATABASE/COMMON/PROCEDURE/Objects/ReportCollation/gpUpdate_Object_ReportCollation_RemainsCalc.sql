-- Function: gpUpdate_Object_ReportCollation_RemainsCalc(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_ReportCollation_RemainsCalc (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReportCollation_RemainsCalc(
    IN inStartDate           TDateTime,    --
    IN inEndDate             TDateTime,    --
    IN inJuridicalId         Integer,      --
    IN inPartnerId           Integer,      --
    IN inContractId          Integer,      --
    IN inPaidKindId          Integer,      --
    IN inSession             TVarChar
)

RETURNS VOID
AS
$BODY$
  DECLARE vbUserId   Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_ReportCollation());

   -- находим элементы по вх. параметрам и расчитываем остатки
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReportCollation_StartRemainsCalc(), tmpObject.Id, SUM (tmpreport.StartRemains))
         , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReportCollation_EndRemainsCalc(), tmpObject.Id, SUM (tmpreport.EndRemains)) 
         , lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_ReCalc(), tmpObject.Id, CURRENT_TIMESTAMP)                -- сохранили свойство <Дата>
         , lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_ReCalc(), tmpObject.Id, vbUserId)                         -- сохранили свойство <Пользователь>
      
         , lpInsert_ObjectProtocol (inObjectId:= tmpObject.Id, inUserId:= vbUserId, inIsUpdate:= FALSE)
   FROM (SELECT Object_ReportCollation.Id
              , Object_ReportCollation.ObjectCode
              , ObjectDate_Start.ValueData      AS StartDate
              , ObjectDate_End.ValueData        AS EndDate
              , COALESCE (ObjectLink_ReportCollation_PaidKind.ChildObjectId , 0) AS PaidKindId
              , COALESCE (ObjectLink_ReportCollation_Contract.ChildObjectId,  0) AS ContractId
              , COALESCE (ObjectLink_ReportCollation_Partner.ChildObjectId,   0) AS PartnerId
              , COALESCE (ObjectLink_ReportCollation_Juridical.ChildObjectId, 0) AS JuridicalId
          FROM Object AS Object_ReportCollation
             LEFT JOIN ObjectDate AS ObjectDate_Start
                                  ON ObjectDate_Start.ObjectId = Object_ReportCollation.Id
                                 AND ObjectDate_Start.DescId = zc_ObjectDate_ReportCollation_Start()
             LEFT JOIN ObjectDate AS ObjectDate_End
                                   ON ObjectDate_End.ObjectId = Object_ReportCollation.Id
                                  AND ObjectDate_End.DescId = zc_ObjectDate_ReportCollation_End()
   
             LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_PaidKind
                                  ON ObjectLink_ReportCollation_PaidKind.ObjectId = Object_ReportCollation.Id
                                 AND ObjectLink_ReportCollation_PaidKind.DescId = zc_ObjectLink_ReportCollation_PaidKind()
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_ReportCollation_PaidKind.ChildObjectId
   
             LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Juridical
                                  ON ObjectLink_ReportCollation_Juridical.ObjectId = Object_ReportCollation.Id
                                 AND ObjectLink_ReportCollation_Juridical.DescId = zc_ObjectLink_ReportCollation_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_ReportCollation_Juridical.ChildObjectId
   
             LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Partner
                                  ON ObjectLink_ReportCollation_Partner.ObjectId = Object_ReportCollation.Id
                                 AND ObjectLink_ReportCollation_Partner.DescId = zc_ObjectLink_ReportCollation_Partner()
             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_ReportCollation_Partner.ChildObjectId
   
             LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Contract
                                  ON ObjectLink_ReportCollation_Contract.ObjectId = Object_ReportCollation.Id
                                 AND ObjectLink_ReportCollation_Contract.DescId = zc_ObjectLink_ReportCollation_Contract()
             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_ReportCollation_Contract.ChildObjectId
   
         WHERE Object_ReportCollation.DescId = zc_Object_ReportCollation()
           AND Object_ReportCollation.isErased = FALSE
           AND ObjectDate_Start.ValueData >= inStartDate
           AND ObjectDate_End.ValueData <= inEndDate
           AND (COALESCE (ObjectLink_ReportCollation_Juridical.ChildObjectId, 0) = inJuridicalId OR inJuridicalId = 0)
           AND (COALESCE (ObjectLink_ReportCollation_Partner.ChildObjectId, 0)   = inPartnerId  OR inPartnerId = 0)
           AND (COALESCE (ObjectLink_ReportCollation_Contract.ChildObjectId, 0)  = inContractId OR inContractId = 0)
           AND (COALESCE (ObjectLink_ReportCollation_PaidKind.ChildObjectId, 0)  = inPaidKindId OR inPaidKindId = 0)
         ) AS tmpObject
         LEFT JOIN gpReport_JuridicalCollation(tmpObject.StartDate, tmpObject.EndDate, tmpObject.JuridicalId, tmpObject.PartnerId, tmpObject.ContractId, 0, tmpObject.PaidKindId,  0,  0,  0, inSession) AS tmpreport ON 1 = 1
   GROUP BY tmpObject.Id;

  
   
  
END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.10.18         *
*/
