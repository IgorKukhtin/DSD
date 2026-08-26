-- Function: gpUpdate_Object_Contract_ContractTag_Load (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Contract_ContractTag_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Contract_ContractTag_Load(
    IN inContractCode               Integer   , -- 
    IN inContractTagName            TVarChar   , -- 
    IN inContractTagGroupName       TVarChar   , --
    IN inContractTagKindName        TVarChar   , -- 
    IN inSession                    TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId             Integer;
    DECLARE vbContractId         Integer;
            vbContractTagGroupId Integer;
            vbContractTagKindId  Integer;
            vbContractTagId      Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Contract());
    -- vbUserId:= lpGetUserBySession (inSession);

    -- Проверка
    IF COALESCE(inContractCode, 0) = 0
    THEN
        RETURN;
    END IF;

    -- Проверка
    IF COALESCE(inContractTagName, '') = ''
    THEN
        RETURN;
    END IF;


    --
    IF COALESCE (inContractCode, 0) <> 0
    THEN 
         -- Проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.ObjectCode = inContractCode AND Object.DescId = zc_Object_Contract() AND Object.isErased = FALSE)
         THEN
             RAISE EXCEPTION 'Ошибка.Договор с кодом = <%> не один.', inContractCode;
         END IF;

         -- поиск договор
         vbContractId:= (SELECT Object.Id
                         FROM Object
                         WHERE Object.ObjectCode = inContractCode
                           AND Object.DescId = zc_Object_Contract()
                           AND Object.isErased = FALSE
                         );

         -- Проверка
         IF COALESCE (vbContractId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Код договора <%> не найден.', inContractCode;
         END IF;
    END IF;
 
    -- 1.1. Группа признака договора
    IF COALESCE (TRIM (inContractTagGroupName), '') <> ''
    THEN 
         -- Проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inContractTagGroupName) AND Object.DescId = zc_Object_ContractTagGroup() AND Object.isErased = FALSE)
         THEN
             RAISE EXCEPTION 'Ошибка.Группа признака договора = <%> не одна.', inContractTagGroupName;
         END IF;


         -- поиск
         vbContractTagGroupId := (SELECT Object.Id
                                  FROM Object
                                  WHERE Object.DescId = zc_Object_ContractTagGroup() 
                                    AND TRIM (Object.ValueData) ILIKE TRIM (inContractTagGroupName)
                                    AND Object.isErased = FALSE
                                 );
         IF COALESCE (vbContractTagGroupId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение Группа признака договора = <%> не найдено.', inContractTagGroupName;
         END IF;
    END IF;

    -- 2.1. Категория признака договора
    IF COALESCE (TRIM (inContractTagKindName), '') <> ''
    THEN 
         -- Проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_ContractTagKind() AND TRIM (Object.ValueData) ILIKE TRIM (inContractTagKindName) AND Object.isErased = FALSE)
         THEN
             RAISE EXCEPTION 'Ошибка.Категория признака договора = <%> не одна.', inContractTagGroupName;
         END IF;

         -- поиск
         vbContractTagKindId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ContractTagKind() AND TRIM (Object.ValueData) ILIKE TRIM (inContractTagKindName) AND Object.isErased = FALSE);
         IF COALESCE (vbContractTagKindId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение Категория признака договора = <%> не найдено.', inContractTagKindName;
         END IF;

    END IF;
    
    -- 3.1. Признак договора
    IF COALESCE (TRIM (inContractTagName), '') <> ''
    THEN 

         -- поиск
         vbContractTagId := (SELECT Object.Id 
                             FROM Object 
                                  LEFT JOIN ObjectLink AS ObjectLink_ContractTag_ContractTagGroup
                                                       ON ObjectLink_ContractTag_ContractTagGroup.ObjectId = Object.Id 
                                                      AND ObjectLink_ContractTag_ContractTagGroup.DescId = zc_ObjectLink_ContractTag_ContractTagGroup()
                                  LEFT JOIN ObjectLink AS ObjectLink_ContractTag_ContractTagKind
                                                       ON ObjectLink_ContractTag_ContractTagKind.ObjectId = Object.Id 
                                                      AND ObjectLink_ContractTag_ContractTagKind.DescId = zc_ObjectLink_ContractTag_ContractTagKind()
                             WHERE Object.DescId = zc_Object_ContractTag()
                               AND TRIM (Object.ValueData) ILIKE TRIM (inContractTagName)
                               AND Object.isErased = FALSE
                               --
                               AND COALESCE (ObjectLink_ContractTag_ContractTagGroup.ChildObjectId,0) = COALESCE (vbContractTagGroupId,0)
                               AND COALESCE (ObjectLink_ContractTag_ContractTagKind.ChildObjectId,0) = COALESCE (vbContractTagKindId,0)
                            );

         IF COALESCE (vbContractTagId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение Признак договора = <%> + Группа <%> + Категория <%> не найдено.', inContractTagName, inContractTagGroupName, inContractTagKindName;
         END IF;
 
    END IF;


    -- сохранили связь с <Признак договора>
    PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractTag(), vbContractId, vbContractTagId);

    -- 5. сохранили протокол
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
 26.08.26         *
*/

-- тест