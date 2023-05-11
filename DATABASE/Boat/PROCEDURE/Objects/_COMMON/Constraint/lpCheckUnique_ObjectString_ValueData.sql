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
     IF inDescId = zc_ObjectString_Product_CIN()
     THEN
         IF EXISTS (SELECT 1 FROM ObjectString AS OS JOIN Object ON Object.Id = ObjectId AND Object.isErased = FALSE
                    WHERE OS.DescId    = inDescId
                      AND LEFT (OS.ValueData, 11) = LEFT (inValueData, 11)
                      AND OS.ObjectId  <> COALESCE (inId, 0)
                   )
         THEN
             --
             SELECT ObjectDesc.ItemName, ObjectStringDesc.ItemName
                    INTO vbObjectName, vbFieldName
             FROM ObjectString
                  LEFT JOIN Object           ON Object.Id          = ObjectString.ObjectId
                  LEFT JOIN ObjectDesc       ON ObjectDesc.Id       = Object.DescId
                  LEFT JOIN ObjectStringDesc ON ObjectStringDesc.Id = ObjectString.DescId
             WHERE ObjectString.DescId    = inDescId
              AND LEFT (OS.ValueData, 11) = LEFT (inValueData, 11)
              AND ObjectString.ObjectId   <> COALESCE (inId, 0);
    
             --
             RAISE EXCEPTION 'Значение <%> не уникально%для поля <%>%в справочнике <%>.', LEFT (inValueData, 11), CHR (13), vbFieldName, CHR (13), vbObjectName;

         END IF;

     ELSE
         IF EXISTS (SELECT 1 FROM ObjectString AS OS JOIN Object ON Object.Id = ObjectId AND Object.isErased = FALSE WHERE OS.DescId = inDescId AND OS.ValueData = inValueData AND OS.ObjectId <> COALESCE (inId, 0))
         THEN
             --
             SELECT ObjectDesc.ItemName, ObjectStringDesc.ItemName
                    INTO vbObjectName, vbFieldName
             FROM ObjectString
                  LEFT JOIN Object           ON Object.Id          = ObjectString.ObjectId
                  LEFT JOIN ObjectDesc       ON ObjectDesc.Id       = Object.DescId
                  LEFT JOIN ObjectStringDesc ON ObjectStringDesc.Id = ObjectString.DescId
             WHERE ObjectString.DescId = inDescId AND ObjectString.ValueData = inValueData AND ObjectString.ObjectId <> COALESCE (inId, 0);
    
             --
             RAISE EXCEPTION 'Значение <%> не уникально%для поля <%>%в справочнике <%>.', inValueData, CHR (13), vbFieldName, CHR (13), vbObjectName;

         END IF;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
