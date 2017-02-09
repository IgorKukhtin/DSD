-- Function: gpInsert_Object_ReportCollation(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsert_Object_ReportCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_ReportCollation(
    IN inStartDate           TDateTime,    --
    IN inEndDate             TDateTime,    --
    IN inJuridicalId         Integer,      --
    IN inPartnerId           Integer,      --
    IN inContractId          Integer,      --
    IN inPaidKindId          Integer,      --
    IN inIsInsert            Boolean,      -- Формировать объект (да/нет)
   OUT outBarCode            TVarChar,     -- штрихкод акта сверки
    IN inSession             TVarChar
)
RETURNS TVarChar
AS
$BODY$
  DECLARE vbId Integer;
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   IF inIsInsert = TRUE 
   THEN vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReportCollation());
   ELSE vbUserId := lpGetUserBySession (inSession);
   END IF;


   IF inIsInsert = TRUE
   THEN
       -- проверка - период должен быть строго за месяц - с первого по последнее число месяца
       IF inStartDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY' <> inEndDate
          OR inStartDate <> DATE_TRUNC ('MONTH', inStartDate)
       THEN
           RAISE EXCEPTION 'Ошибка.Период должен быть строго за 1 месяц с <%> по <%>.', zfConvert_DateToString (DATE_TRUNC ('MONTH', inStartDate)), zfConvert_DateToString (inStartDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY');
       END IF;


       -- поиск существующего акта сверки: период, юр.лицо, контрагент, договор, форма оплаты
       vbId:= (SELECT ObjectDate_Start.ObjectId
               FROM ObjectDate AS ObjectDate_Start
                  INNER JOIN ObjectDate AS ObjectDate_End 
                                        ON ObjectDate_End.ObjectId = ObjectDate_Start.ObjectId
                                       AND ObjectDate_End.DescId = zc_ObjectDate_ReportCollation_End()
                                       AND ObjectDate_End.ValueData = inEndDate

                  INNER JOIN ObjectLink AS ObjectLink_ReportCollation_PaidKind
                                       ON ObjectLink_ReportCollation_PaidKind.ObjectId = ObjectDate_Start.ObjectId
                                      AND ObjectLink_ReportCollation_PaidKind.DescId = zc_ObjectLink_ReportCollation_PaidKind()
                                      AND (ObjectLink_ReportCollation_PaidKind.ChildObjectId = COALESCE (inPaidKindId,0) OR COALESCE (inPaidKindId,0)=0)

                  INNER JOIN ObjectLink AS ObjectLink_ReportCollation_Juridical
                                        ON ObjectLink_ReportCollation_Juridical.ObjectId = ObjectDate_Start.ObjectId
                                       AND ObjectLink_ReportCollation_Juridical.DescId = zc_ObjectLink_ReportCollation_Juridical()
                                       AND (ObjectLink_ReportCollation_Juridical.ChildObjectId = COALESCE (inJuridicalId,0) OR COALESCE (inJuridicalId,0)=0)

                  INNER JOIN ObjectLink AS ObjectLink_ReportCollation_Partner
                                        ON ObjectLink_ReportCollation_Partner.ObjectId = ObjectDate_Start.ObjectId
                                       AND ObjectLink_ReportCollation_Partner.DescId = zc_ObjectLink_ReportCollation_Partner()
                                       AND (ObjectLink_ReportCollation_Partner.ChildObjectId = COALESCE (inPartnerId,0) OR COALESCE (inPartnerId,0)=0)

                  INNER JOIN ObjectLink AS ObjectLink_ReportCollation_Contract
                                        ON ObjectLink_ReportCollation_Contract.ObjectId = ObjectDate_Start.ObjectId
                                       AND ObjectLink_ReportCollation_Contract.DescId = zc_ObjectLink_ReportCollation_Contract()
                                       AND (ObjectLink_ReportCollation_Contract.ChildObjectId = COALESCE (inContractId,0) OR COALESCE (inContractId,0)=0)

              WHERE ObjectDate_Start.DescId = zc_ObjectDate_ReportCollation_Start()
                AND ObjectDate_Start.ValueData= inStartDate
             );

         -- сохранили <Объект>
         vbId := lpInsertUpdate_Object( COALESCE (vbId, 0), zc_Object_ReportCollation(), 0, '');

         --
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_Juridical(), vbId, COALESCE (inJuridicalId,0));
         --
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_Partner(), vbId, COALESCE (inPartnerId,0));
         --
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_Contract(), vbId, COALESCE (inContractId,0));
         --
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportCollation_PaidKind(), vbId, COALESCE (inPaidKindId,0));

         -- сохранили свойство <Дата начала периода>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_Start(), vbId, inStartDate);
         -- сохранили свойство <Дата окончания периода>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_End(), vbId, inEndDate);

         -- сохранили свойство <Дата создания>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_Insert(), vbId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (создание)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportCollation_Insert(), vbId, vbUserId);
      
    
   END IF;

   -- Результат
   outBarCode := (SELECT zfFormat_BarCode (zc_BarCodePref_Object(), vbId));
  
END;$BODY$
 LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.01.17         *

*/
