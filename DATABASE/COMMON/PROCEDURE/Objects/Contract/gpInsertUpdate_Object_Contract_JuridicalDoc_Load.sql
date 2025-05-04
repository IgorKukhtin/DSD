-- Function: gpInsertUpdate_Object_Contract_JuridicalDoc_Load (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract_JuridicalDoc_Load (TVarChar, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Contract_JuridicalDoc_Load(
    IN inJuridicalName              TVarChar   , 
    IN inContractCode               Integer   , -- 
    IN inContractName               TVarChar   , -- 
    IN inPaidKindName               TVarChar   , -- 
    IN inJuridicalDocName           TVarChar   , -- 
    IN inJuridicalDoc_NextName      TVarChar   , --
    IN inJuridicalDoc_NextDate      TDateTime   ,  
    IN inSession                    TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbPaidKindId Integer;
    DECLARE vbContractId Integer;
    DECLARE vbJuridicalId Integer;
    DECLARE vbJuridicalDocId Integer;
    DECLARE vbJuridicalDoc_NextId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

    -- Проверка
    IF COALESCE(inContractCode, 0) = 0
    THEN
        RETURN;
    END IF;
    -- Проверка
    IF COALESCE(TRIM (inJuridicalName), '') = ''
    THEN
        RETURN;
    END IF;

    -- Проверка
    IF COALESCE(inPaidKindName, '') = ''
    THEN
        RAISE EXCEPTION 'Ошибка.Значение Форма оплаты <%> не определено для <%> договор <%>.', inJuridicalName, inContractName;
    END IF;

    IF COALESCE (TRIM (inPaidKindName), '') <> ''
    THEN 
         -- поиск ФО
         vbPaidKindId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PaidKind() AND Object.ValueData ILIKE inPaidKindName);
         IF COALESCE (vbPaidKindId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение Форма оплаты <%> не найдено.', inPaidKindName;
         END IF;
    END IF;

    
    IF COALESCE (TRIM (inJuridicalName), '') <> ''
    THEN
         -- проверка на несколько значений 
         IF 1 < (SELECT COUNT (*) FROM Object
                 WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                   AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) = zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                )
         
         THEN
             -- временно - Выход
             -- RETURN;
             --
             RAISE EXCEPTION 'Ошибка.Значение Юридическое лицо(1) <%> найдено более одного раза.', inJuridicalName;
         END IF;
          
         -- поиск-1 юр.лица
         vbJuridicalId := (SELECT Object.Id FROM Object
                           WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                             AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) = zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                          );

         -- если не нашли - после 1
         IF COALESCE (vbJuridicalId, 0) = 0
         THEN
             -- проверка на несколько значений 
             IF 1 < (SELECT COUNT (*) FROM Object
                     WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                       AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                    )
             
             THEN 
                 -- временно - Выход
                 -- RETURN;
                 --
                 RAISE EXCEPTION 'Ошибка.Значение Юридическое лицо(1) <%> найдено более одного раза.', inJuridicalName;
             END IF;
         
            -- поиск-2 юр.лица
            vbJuridicalId := (SELECT Object.Id FROM Object
                              WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                                AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                             );
         END IF;

         -- если не нашли - после 2
         IF COALESCE (vbJuridicalId, 0) = 0
         THEN
             -- проверка на несколько значений 
             IF 1 < (SELECT COUNT (*) FROM Object
                     WHERE Object.DescId = zc_Object_Juridical() -- AND Object.isErased = FALSE
                       AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) = zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                    )
             
             THEN 
                 -- временно - Выход
                 -- RETURN;
                 --
                 RAISE EXCEPTION 'Ошибка.Значение Юридическое лицо(1) <%> найдено более одного раза.', inJuridicalName;
             END IF;

             -- поиск-3 юр.лица
             vbJuridicalId := (SELECT Object.Id FROM Object
                               WHERE Object.DescId = zc_Object_Juridical() -- AND Object.isErased = FALSE
                                 AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) = zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                              );
         END IF;

         -- если не нашли - после 3
         IF COALESCE (vbJuridicalId, 0) = 0
         THEN
             -- проверка на несколько значений 
             IF 1 < (SELECT COUNT (*) FROM Object
                     WHERE Object.DescId = zc_Object_Juridical() -- AND Object.isErased = FALSE
                       AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                    )
             
             THEN 
                 -- временно - Выход
                 -- RETURN;
                 --
                 RAISE EXCEPTION 'Ошибка.Значение Юридическое лицо(1) <%> найдено более одного раза.', inJuridicalName;
             END IF;

             -- поиск-4 юр.лица
             vbJuridicalId := (SELECT Object.Id FROM Object
                               WHERE Object.DescId = zc_Object_Juridical() -- AND Object.isErased = FALSE
                                 AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalName), CHR (39), '`' )
                              );
         END IF;

         -- Проверка - если не нашли - после 4
         IF COALESCE (vbJuridicalId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение Юридическое лицо(1) <%> не найдено.', inJuridicalName;
         END IF;

    END IF;
    
    
    IF COALESCE (TRIM (inJuridicalDocName), '') <> ''
    THEN 
         IF 1 < (SELECT COUNT (*) FROM Object
                 WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                   AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalDocName), CHR (39), '`' )
                )
         THEN 
             RAISE EXCEPTION 'Ошибка.Значение Юридическое лицо(2) <%> найдено более одного раза.', inJuridicalDocName;
         END IF;

         -- поиск юр.лица
         vbJuridicalDocId := (SELECT Object.Id FROM Object
                              WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                                AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalDocName), CHR (39), '`' )
                             );

         -- Проверка
         IF COALESCE (vbJuridicalDocId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение Юридическое лицо(2) <%> не найдено.', inJuridicalDocName;
         END IF;
    END IF;


    IF COALESCE (TRIM (inJuridicalDoc_NextName), '') <> ''
    THEN 
         IF 1 < (SELECT COUNT (*) FROM Object
                 WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                   AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalDoc_NextName), CHR (39), '`' )
                 )
         THEN 
             RAISE EXCEPTION 'Ошибка.Значение Юридическое лицо(3) <%> найдено более одного раза.', inJuridicalDoc_NextName;
         END IF;

         -- поиск юр.лица
         vbJuridicalDoc_NextId := (SELECT Object.Id FROM Object
                                   WHERE Object.DescId = zc_Object_Juridical() AND Object.isErased = FALSE
                                     AND zfCalc_Text_replace (TRIM (Object.ValueData), CHR (39), '`' ) ILIKE zfCalc_Text_replace (TRIM (inJuridicalDoc_NextName), CHR (39), '`' )
                                  );

         -- Проверка
         IF COALESCE (vbJuridicalDoc_NextId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение Юридическое лицо(3) <%> не найдено.', inJuridicalDoc_NextName;
         END IF;
    END IF;



    IF COALESCE (inContractCode, 0) <> 0
    THEN 
         -- поиск договор
         vbContractId:= (SELECT tmp_View.ContractId
                         FROM Object_Contract_View AS tmp_View
                         WHERE tmp_View.JuridicalId = vbJuridicalId
                           AND tmp_View.PaidKindId  = vbPaidKindId
                           AND tmp_View.ContractCode = inContractCode
                         );

         -- Проверка
         IF COALESCE (vbContractId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Договор <(%) %> не найден %для <%> + <%>.'
                           , inContractCode, inContractName
                           , CHR (13)
                           , lfGet_Object_ValueData_sh (vbJuridicalId), lfGet_Object_ValueData_sh (vbPaidKindId)
                            ;
         END IF;
    END IF;

   -- сохранили связь с <Юридическое лицо(печать док.)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_JuridicalDocument(), vbContractId, vbJuridicalDocId);
   -- сохранили связь с <Юр. лица история(печать док.)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_JuridicalDoc_Next(), vbContractId, vbJuridicalDoc_NextId);
   -- сохранили свойство <Дата для Юр. лица история(печать док.)>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_JuridicalDoc_Next(), vbContractId, inJuridicalDoc_NextDate ::TDateTime);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= vbContractId, inUserId:= vbUserId, inIsUpdate:= TRUE, inIsErased:= NULL);

   -- проверка - что б Админ ничего не ломал
   IF vbUserId = 5 OR vbUserId = 9457
   THEN
       RAISE EXCEPTION 'Ошибка.Нет прав - что б Админ ничего не ломал.';
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.04.25         *
*/

-- тест
