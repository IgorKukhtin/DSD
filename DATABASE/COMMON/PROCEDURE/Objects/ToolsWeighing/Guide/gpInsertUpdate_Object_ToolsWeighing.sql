-- Function: gpInsertUpdate_Object_ToolsWeighing

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ToolsWeighing (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ToolsWeighing(
 INOUT ioId                      Integer   , -- ����
    IN inCode                    Integer   , -- ���
    IN inName                    TVarChar  , -- ��������
    IN inNameUser                TVarChar  , -- �������� ��� ������������
    IN inValue                   TVarChar  , -- ��������
    IN inNameFull                TVarChar  , -- ������ ��������
    IN inParentId                Integer   , -- ������
    IN inSession                 TVarChar    -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ToolsWeighing());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������
   IF TRIM (COALESCE (inName, '')) = '' THEN RAISE EXCEPTION '�������. inName = <%>', inName; END IF;
   -- ��������
   IF inNameFull <> '' AND TRIM (COALESCE (inValue, '')) = '' THEN RAISE EXCEPTION '�������. inValue = <%>   inName = <%>   inNameFull = <%>', inValue, inName, inNameFull; END IF;
   -- ��������
   IF inNameFull <> '' AND COALESCE (inParentId, 0) = 0 THEN RAISE EXCEPTION '�������. inParentId �� ����� ���� null ��� inName = <%>', inName; END IF;
   -- ��������
   IF ioId <> 0 AND NOT EXISTS (SELECT ObjectId FROM ObjectLink WHERE ObjectId = ioId AND DescId = zc_ObjectLink_ToolsWeighing_Parent() AND COALESCE (ChildObjectId, 0) <> COALESCE (inParentId, 0))
   THEN RAISE EXCEPTION '�������. inParentId �� ����� ���������� ��� inName = <%>', inName; END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_ToolsWeighing());

   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ToolsWeighing(), vbCode_calc);
   -- �������� ������������ <������������> ��� ������ ������
   IF EXISTS (SELECT ObjectLink.ChildObjectId
              FROM ObjectLink
                   JOIN ObjectString ON ObjectString.ObjectId = ObjectLink.ObjectId
                                    AND TRIM (ObjectString.ValueData) = TRIM (inName)
              WHERE COALESCE (ObjectLink.ChildObjectId, 0) = COALESCE (inParentId, 0)
                AND ObjectLink.ObjectId <> COALESCE (ioId, 0)
                AND ObjectLink.DescId = zc_ObjectLink_ToolsWeighing_Parent())
   THEN
       RAISE EXCEPTION '������. ������� <%> ��� ���������� � ������ <%>(%). inNameFull = <%>   inParentId = <%>', TRIM (inName), (SELECT ValueData FROM ObjectString WHERE ObjectId = inParentId AND DescId = zc_ObjectString_ToolsWeighing_Name()), (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = inParentId AND DescId = zc_ObjectBoolean_isLeaf()), inNameFull, inParentId;
   END IF;


   -- �������� ���� � ������
   PERFORM lpCheck_Object_CycleLink (ioId, zc_ObjectLink_ToolsWeighing_Parent(), inParentId);


   -- ��������� ������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ToolsWeighing(), vbCode_calc, inValue, inAccessKeyId:= NULL);

   -- ��������� ����� � <��������� �����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ToolsWeighing_Parent(), ioId, inParentId);
   -- ��������� �������� <������ ��������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ToolsWeighing_NameFull(), ioId, inNameFull);
   -- ��������� �������� <��������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ToolsWeighing_Name(), ioId, inName);
   -- ��������� �������� <�������� ��� ������������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ToolsWeighing_NameUser(), ioId
                                      , COALESCE ((SELECT OS_ToolsWeighing_NameUser.ValueData
                                                   FROM ObjectString AS OS_ToolsWeighing_Name
                                                        INNER JOIN ObjectString AS OS_ToolsWeighing_NameUser
                                                                                ON OS_ToolsWeighing_NameUser.ObjectId  = OS_ToolsWeighing_Name.ObjectId
                                                                               AND OS_ToolsWeighing_NameUser.DescId    = zc_ObjectString_ToolsWeighing_NameUser()
                                                                               AND OS_ToolsWeighing_NameUser.ValueData <> ''
                                                   WHERE OS_ToolsWeighing_Name.ValueData = inName
                                                     AND OS_ToolsWeighing_Name.ObjectId <> ioId
                                                     AND OS_ToolsWeighing_Name.DescId    = zc_ObjectString_ToolsWeighing_Name()
                                                   ORDER BY OS_ToolsWeighing_NameUser.ValueData DESC
                                                   LIMIT 1
                                                  )
                                                , inNameUser)
                                      );

   -- ���������� �������� ����\����� � ����
   IF TRIM (inNameFull) <> ''
   THEN
      -- �������
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), ioId, TRUE);
    ELSE
      -- ������ 
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), ioId, FALSE);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= FALSE, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ToolsWeighing (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.01.15                                        * all
 12.03.14                                                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ToolsWeighing (0, 0, 'Name','NameUser', 'Value', 'NameFull', 0, '5')
