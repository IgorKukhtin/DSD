-- Function: gpInsert_Object_ReportCollation(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsert_Object_ReportCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION gpInsert_Object_ReportCollation(
    IN inStartDate           TDateTime,    --
    IN inEndDate             TDateTime,    --
    IN inJuridicalId         Integer,      --
    IN inPartnerId           Integer,      --
    IN inContractId          Integer,      --
    IN inPaidKindId          Integer,      --
    IN inisInsert            Boolean,      -- Записывать да/нет объект 
   OUT outBarCode            TVarChar,      -- штрихкод акта сверки
    IN inUserId              Integer
)
RETURNS TVarChar
AS
$BODY$
DECLARE vbId Integer;
BEGIN

   -- поиск существующего акта сверки период, юр.лицо, контрагент, договор, форма оплаты
   SELECT ObjectDate_Start.ObjectId
 INTO vbId
   FROM ObjectDate AS ObjectDate_Start
      INNER JOIN ObjectDate AS ObjectDate_End 
                            ON ObjectDate_End.ObjectId = ObjectDate_Start.ObjectId
                           AND ObjectDate_End.DescId = zc_ObjectDate_ReportCollation_End()
                           --AND ObjectDate_End.ValueDate = inEndDate
      INNER JOIN ObjectLink AS ObjectLink_ReportCollation_PaidKind
                           ON ObjectLink_ReportCollation_PaidKind.ObjectId = ObjectDate_Start.ObjectId
                          AND ObjectLink_ReportCollation_PaidKind.DescId = zc_ObjectLink_ReportCollation_PaidKind()
                         -- AND ObjectLink_ReportCollation_PaidKind.ChildObjectId = inPaidKind
      LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Juridical
                           ON ObjectLink_ReportCollation_Juridical.ObjectId = ObjectDate_Start.ObjectId
                          AND ObjectLink_ReportCollation_Juridical.DescId = zc_ObjectLink_ReportCollation_Juridical()
      LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Partner
                           ON ObjectLink_ReportCollation_Partner.ObjectId = ObjectDate_Start.ObjectId
                          AND ObjectLink_ReportCollation_Partner.DescId = zc_ObjectLink_ReportCollation_Partner()
      LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Contract
                           ON ObjectLink_ReportCollation_Contract.ObjectId = ObjectDate_Start.ObjectId
                          AND ObjectLink_ReportCollation_Contract.DescId = zc_ObjectLink_ReportCollation_Contract()
  WHERE ObjectDate_Start.DescId = zc_ObjectDate_ReportCollation_Start()
/* AND ObjectDate_Start.ValueDate = inStartDate
  AND (ObjectLink_ReportCollation_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
  AND (ObjectLink_ReportCollation_Partner.ChildObjectId = inPartnerId OR inPartnerId = 0)
  AND (ObjectLink_ReportCollation_Contract.ChildObjectId = inContractId OR inContractId = 0)
*/
 ;
     
                    
   IF COALESCE (inisInsert, FALSE) = TRUE THEN
         -- сохранили <Объект>
         vbId := lpInsertUpdate_Object( COALESCE (vbId, 0), zc_Object_ReportCollation(), 0, '');

         --
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_Juridical(), vbId, inJuridicalId);
         --
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_Partner(), vbId, inPartnerId);
         --
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_Contract(), vbId, inContractId);
         --
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_PaidKind(), vbId, inPaidKindId);

         -- сохранили свойство <Дата начала периода>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_Start(), vbId, inStartDate);
         -- сохранили свойство <Дата окончания периода>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_End(), vbId, inEndDate);

         -- сохранили свойство <Дата создания>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_Insert(), vbId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (создание)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportCollation_Insert(), vbId, inUserId);
      
    
   END IF;

  outBarCode := (SELECT zfFormat_BarCode (zc_BarCodePref_Object(), vbId)) ;
  
END;$BODY$
 LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.01.17         *

*/

-- тест
-- SELECT * FROM gpInsert_Object_ReportCollation()