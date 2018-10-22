DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RepriceUnitSheduler (Integer, Integer, Integer, Boolean, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RepriceUnitSheduler(
 INOUT ioId                 Integer,    -- ИД
    IN inJuridicalId        Integer, 
    IN inPercentDifference  Integer, 
    IN inVAT20              Boolean,
    IN inPercentRepriceMax  Integer, 
    IN inPercentRepriceMin  Integer, 
    IN inEqualRepriceMax    Integer, 
    IN inEqualRepriceMin    Integer, 
    IN inSession            TVarChar   -- Сессия
)
AS
$BODY$
    DECLARE vbPlanAmount TFloat;
    DECLARE vbUserId Integer;
BEGIN
    -- Определяем пользователя
    vbUserId := inSession;

    -- Если такая запись есть
    IF COALESCE (ioId, 0) = 0
    THEN
      IF EXISTS(SELECT * FROM ObjectLink WHERE DescId = zc_ObjectLink_RepriceUnitSheduler_Juridical() 
                                           AND ChildObjectId = inJuridicalId)
      THEN
        RAISE EXCEPTION 'Ошибка.По нашему юр. лицу <%> задание уже создано', (SELECT ValueData FROM Object WHERE Id = inJuridicalId);
      END IF;
    ELSE
      IF EXISTS(SELECT * FROM ObjectLink WHERE DescId = zc_ObjectLink_RepriceUnitSheduler_Juridical() 
                                           AND ObjectId <> ioId
                                           AND ChildObjectId = inJuridicalId)
      THEN
        RAISE EXCEPTION 'Ошибка.По нашему юр. лицу <%> задание уже создано', (SELECT ValueData FROM Object WHERE Id = inJuridicalId);
      END IF;    
    END IF;
        
    -- сохранили/получили <Объект> по ИД
    ioId := lpInsertUpdate_Object (ioId, zc_Object_RepriceUnitSheduler(), 0, '');

    -- сохранили связь с <Наше юр. лицо>
    PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RepriceUnitSheduler_Juridical(), ioId, inJuridicalId);
        
    --сохранили 
    PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RepriceUnitSheduler_PercentDifference(), ioId, inPercentDifference);

    --сохранили 
    PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_RepriceUnitSheduler_VAT20(), ioId, inVAT20);
    
    --сохранили 
    PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMax(), ioId, inPercentRepriceMax);

    --сохранили 
    PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMin(), ioId, inPercentRepriceMin);

    --сохранили 
    PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMax(), ioId, inEqualRepriceMax);

    --сохранили 
    PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMin(), ioId, inEqualRepriceMin);
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_RepriceUnitSheduler (Integer, Integer, Integer, Boolean, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 22.10.18        *
 */
