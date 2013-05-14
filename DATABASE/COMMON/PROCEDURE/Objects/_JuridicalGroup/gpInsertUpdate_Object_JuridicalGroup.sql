-- Function: gpInsertUpdate_Object_JuridicalGroup()

-- DROP FUNCTION gpInsertUpdate_Object_JuridicalGroup();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalGroup(
INOUT ioId	         Integer   ,   	/* ключ объекта <Группа юр лиц> */
IN inCode                Integer   ,    /* Код объекта <Группа юр лиц> */
IN inName                TVarChar  ,    /* Название объекта <Группа юр лиц> */
IN inJuridicalGroupId    Integer   ,    /* ссылка на группу юр лиц */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_JuridicalGroup());

   -- Проверем уникальность имени
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_JuridicalGroup(), inName);
   -- Проверем цикл у дерева
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_JuridicalGroup_Parent(), inJuridicalGroupId);

   -- Вставляем объект
   ioId := lpInsertUpdate_Object(ioId, zc_Object_JuridicalGroup(), inCode, inName);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalGroup_Parent(), ioId, inJuridicalGroupId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_JuridicalGroup(Integer, Integer, TVarChar, Integer, tvarchar)
  OWNER TO postgres;

  
                            