-- Function: gpUpdate_Object_Translate

DROP FUNCTION IF EXISTS gpUpdate_Object_Translate (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Translate(
    IN inId                       Integer   ,    --  <������������� �������>
    IN inLanguageId1              Integer   ,    --
    IN inLanguageId2              Integer   ,    -- ���� ������� <>
    IN inLanguageId3              Integer   ,    --
    IN inLanguageId4              Integer   ,    --  
    IN inValue1                   TVarChar  ,
    IN inValue2                   TVarChar  ,
    IN inValue3                   TVarChar  ,
    IN inValue4                   TVarChar  ,   
    IN inDescCode                 TVarChar  ,
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbId_tr    Integer;
           vbCode_tr  Integer;
   DECLARE vbId       Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_TranslateWord());
   vbUserId:= lpGetUserBySession (inSession);

   -- ������� 1
   IF COALESCE (inValue1,''::TVarChar) <> ''  AND COALESCE (inLanguageId1,0) <> 0
   THEN
       --������� ����� ����������� �������
       SELECT Object_TranslateObject.Id AS Id 
            , Object_TranslateObject.ObjectCode  AS Code
     INTO vbId_tr, vbCode_tr
       FROM Object AS Object_TranslateObject
          INNER JOIN ObjectLink AS ObjectLink_Language
                                ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                               AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                               AND ObjectLink_Language.ChildObjectId = inLanguageId1

          INNER JOIN ObjectLink AS ObjectLink_Object
                                ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                               AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                               AND ObjectLink_Object.ChildObjectId = inId
          INNER JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId
          INNER JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId AND ObjectDesc.Code = inDescCode

       WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
         AND Object_TranslateObject.isErased = FALSE
       ;
       -- ��������� �������
       PERFORM gpInsertUpdate_Object_TranslateObject( ioId          := COALESCE (vbId_tr,0)::Integer,       -- ���� ������� <>
                                                      ioCode        := COALESCE (vbCode_tr,0)    ::Integer,       -- �������� <��� 
                                                      inName        := TRIM (inValue1)           ::TVarChar,      -- �������� 
                                                      inLanguageId  := inLanguageId1             ::Integer,
                                                      inObjectId    := inId                      ::Integer,
                                                      inComment     := ''                        ::TVarChar,
                                                      inSession     := inSession                 ::TVarChar
                                                     );
   END IF;
   
   -- ������� 2
   vbId_tr := 0; vbCode_tr := 0;
   IF COALESCE (inValue2,''::TVarChar) <> ''  AND COALESCE (inLanguageId2,0) <> 0
   THEN
       --������� ����� ����������� �������
       SELECT Object_TranslateObject.Id AS Id 
            , Object_TranslateObject.ObjectCode  AS Code
     INTO vbId_tr, vbCode_tr
       FROM Object AS Object_TranslateObject
          INNER JOIN ObjectLink AS ObjectLink_Language
                                ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                               AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                               AND ObjectLink_Language.ChildObjectId = inLanguageId2

          INNER JOIN ObjectLink AS ObjectLink_Object
                                ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                               AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                               AND ObjectLink_Object.ChildObjectId = inId
          INNER JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId
          INNER JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId AND ObjectDesc.Code = inDescCode

       WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
         AND Object_TranslateObject.isErased = FALSE
       ;
       -- ��������� �������
       PERFORM gpInsertUpdate_Object_TranslateObject( ioId          := COALESCE (vbId_tr,0)::Integer,       -- ���� ������� <>
                                                      ioCode        := COALESCE (vbCode_tr,0)    ::Integer,       -- �������� <��� 
                                                      inName        := TRIM (inValue2)           ::TVarChar,      -- �������� 
                                                      inLanguageId  := inLanguageId2             ::Integer,
                                                      inObjectId    := inId                      ::Integer,
                                                      inComment     := ''                        ::TVarChar,
                                                      inSession     := inSession                 ::TVarChar
                                                     );
   END IF; 
   

   -- ������� 3
   vbId_tr := 0; vbCode_tr := 0;
   IF COALESCE (inValue3,''::TVarChar) <> ''  AND COALESCE (inLanguageId3,0) <> 0
   THEN
       --������� ����� ����������� �������
       SELECT Object_TranslateObject.Id AS Id 
            , Object_TranslateObject.ObjectCode  AS Code
     INTO vbId_tr, vbCode_tr
       FROM Object AS Object_TranslateObject
          INNER JOIN ObjectLink AS ObjectLink_Language
                                ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                               AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                               AND ObjectLink_Language.ChildObjectId = inLanguageId3

          INNER JOIN ObjectLink AS ObjectLink_Object
                                ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                               AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                               AND ObjectLink_Object.ChildObjectId = inId
          INNER JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId 
          INNER JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId AND ObjectDesc.Code = inDescCode

       WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
         AND Object_TranslateObject.isErased = FALSE
       ;
       -- ��������� �������
       PERFORM gpInsertUpdate_Object_TranslateObject( ioId          := COALESCE (vbId_tr,0)::Integer,       -- ���� ������� <>
                                                      ioCode        := COALESCE (vbCode_tr,0)    ::Integer,       -- �������� <��� 
                                                      inName        := TRIM (inValue3)           ::TVarChar,      -- �������� 
                                                      inLanguageId  := inLanguageId3             ::Integer,
                                                      inObjectId    := inId                      ::Integer, 
                                                      inComment     := ''                        ::TVarChar,
                                                      inSession     := inSession                 ::TVarChar
                                                     );
   END IF;

   -- ������� 4
   vbId_tr := 0; vbCode_tr := 0;
   IF COALESCE (inValue4,''::TVarChar) <> ''  AND COALESCE (inLanguageId4,0) <> 0
   THEN
       --������� ����� ����������� �������
       SELECT Object_TranslateObject.Id AS Id 
            , Object_TranslateObject.ObjectCode  AS Code
     INTO vbId_tr, vbCode_tr
       FROM Object AS Object_TranslateObject
          INNER JOIN ObjectLink AS ObjectLink_Language
                                ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                               AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                               AND ObjectLink_Language.ChildObjectId = inLanguageId4

          INNER JOIN ObjectLink AS ObjectLink_Object
                                ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                               AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                               AND ObjectLink_Object.ChildObjectId = inId
          INNER JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId
          INNER JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId AND ObjectDesc.Code = inDescCode

       WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
         AND Object_TranslateObject.isErased = FALSE
       ;
       -- ��������� �������
       PERFORM gpInsertUpdate_Object_TranslateObject( ioId          := COALESCE (vbId_tr,0)::Integer,       -- ���� ������� <>
                                                      ioCode        := COALESCE (vbCode_tr,0)    ::Integer,       -- �������� <��� 
                                                      inName        := TRIM (inValue4)           ::TVarChar,      -- �������� 
                                                      inLanguageId  := inLanguageId4             ::Integer,
                                                      inObjectId    := inId                      ::Integer,
                                                      inComment     := ''                        ::TVarChar,
                                                      inSession     := inSession                 ::TVarChar
                                                     );
   END IF;




END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
26.04.20          *
*/

-- ����
--