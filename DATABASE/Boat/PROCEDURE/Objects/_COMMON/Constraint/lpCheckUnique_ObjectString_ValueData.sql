-- Function: lpCheckUnique_ObjectString_ValueData(integer, tvarchar)

-- DROP FUNCTION lpCheckUnique_ObjectString_ValueData(integer, tvarchar);

-- Процедура проверяет уникальность поля ValueData у объекта

CREATE OR REPLACE FUNCTION lpCheckUnique_ObjectString_ValueData(
        inId        integer,
        inDescId    integer,
        inValueData tvarchar,
        inUserId    integer)
RETURNS VOID
AS
$BODY$
  DECLARE vbObjectName TVarChar;
  DECLARE vbFieldName TVarChar;
BEGIN
     IF EXISTS (SELECT ValueData FROM ObjectString WHERE DescId = inDescId AND ValueData = inValueData AND ObjectId <> COALESCE (inId, 0))
     THEN

         --
         SELECT ObjectDesc.ItemName, ObjectStringDesc.ItemName
                INTO vbObjectName, vbFieldName
         FROM ObjectString
              LEFT JOIN Object           ON Object.Id           = ObjectString.ObjectId
              LEFT JOIN ObjectDesc       ON ObjectDesc.Id       = Object.DescId
              LEFT JOIN ObjectStringDesc ON ObjectStringDesc.Id = ObjectString.DescId
         WHERE ObjectString.DescId = inDescId AND ObjectString.ValueData = inValueData AND ObjectString.ObjectId <> COALESCE (inId, 0);

         --
         RAISE EXCEPTION 'Значение <%> не уникально для поля <%> справочника <%>.', inValueData, vbFieldName, vbObjectName;

         /*RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Значение "<%>" не уникально для поля "<%>" справочника "<%>"' :: TVarChar
                                                 , inProcedureName := 'lpCheckUnique_ObjectString_ValueData'    :: TVarChar
                                                 , inUserId        := inUserId
                                                 , inParam1        := inValueData :: TVarChar
                                                 , inParam2        := vbFieldName   :: TVarChar
                                                 , inParam3        := vbObjectName  :: TVarChar
                                                 );*/
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
