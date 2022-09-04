-- Function: lpInsertUpdate_Object_Calendar(Integer, Boolean, TDateTime, TVarChar,TVarChar )

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_JuridicalDefermentPayment (Integer, Integer, Integer, TDateTime, TFloat, Integer );
--DROP FUNCTION IF EXISTS lpInsertUpdate_Object_JuridicalDefermentPayment (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, Integer );
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_JuridicalDefermentPayment (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TDateTime, TFloat, Integer );

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_JuridicalDefermentPayment (
    IN inId                Integer   , -- ключ объекта <>
    IN inJuridicalId       Integer   , -- 
    IN inContractId        Integer   , -- 
    IN inPaidKindId        Integer   , -- 
    IN inPartnerId         Integer   , -- 
    IN inOperDate          TDateTime , -- Дата последней оплаты
    IN inAmount            TFloat    , -- сумма последней оплаты 
    IN inOperDateIn        TDateTime , -- Дата последнего прихода
    IN inAmountIn          TFloat    , -- сумма последнего прихода
    IN inUserId            Integer 
)
RETURNS VOID AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- сохранили <Объект>
   inId := lpInsertUpdate_Object (inId, zc_Object_JuridicalDefermentPayment(), 0, '');
   
   -- сохранили связь с <Юридическое лицо>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalDefermentPayment_Juridical(), inId, inJuridicalId);
   -- сохранили связь с <Договор>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalDefermentPayment_Contract(), inId, inContractId);  
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalDefermentPayment_PaidKind(), inId, inPaidKindId); 
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalDefermentPayment_Partner(), inId, inPartnerId); 

   -- сохранили свойство <>   
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_JuridicalDefermentPayment_OperDate(), inId, inOperDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_JuridicalDefermentPayment_Amount(), inId, inAmount);
   
    -- сохранили свойство <>   
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_JuridicalDefermentPayment_OperDateIn(), inId, inOperDateIn);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_JuridicalDefermentPayment_AmountIn(), inId, inAmountIn);
     
   -- сохранили протокол
   --PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.12.21         *
 02.12.21         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_Calendar (0,  true, '12.11.2013')