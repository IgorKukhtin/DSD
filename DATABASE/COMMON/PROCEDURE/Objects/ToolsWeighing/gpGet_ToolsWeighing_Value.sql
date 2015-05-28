-- Function: gpGet_ToolsWeighing_Value

DROP FUNCTION IF EXISTS gpGetToolsPropertyId (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGetToolsPropertyValue (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_ToolsWeighing_Value (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ToolsWeighing_Value(
    IN inLevel1                  TVarChar  ,
    IN inLevel2                  TVarChar  ,
    IN inLevel3                  TVarChar  ,
    IN inItemName                TVarChar  ,
    IN inDefaultValue            TVarChar  ,
    IN inSession                 TVarChar
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbNameFull TVarChar;
   DECLARE vbToolsId Integer;
   DECLARE vbParentId Integer;
   DECLARE vbValue TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ToolsWeighing());


   IF TRIM (COALESCE (inLevel1, '')) = '' THEN RAISE EXCEPTION '�������. inLevel1 = <%>', inLevel1; END IF;
   IF TRIM (COALESCE (inItemName, '')) = '' THEN RAISE EXCEPTION '�������. inItemName = <%>   inLevel1 = <%>  inLevel2 = <%>  inLevel3 = <%>', inItemName, inLevel1, inLevel2, inLevel3; END IF;

   -- ������ <������ ��������>
   vbNameFull:= inLevel1
             || CASE WHEN inLevel2 <> '' THEN ' '|| inLevel2 ELSE '' END
             || CASE WHEN inLevel3 <> '' THEN ' '|| inLevel3 ELSE '' END
             || ' '|| inItemName;

   -- ������� �������� ��� <������ ��������>
   vbValue:= (SELECT Object_ToolsWeighing_View.ValueData FROM Object_ToolsWeighing_View WHERE Object_ToolsWeighing_View.NameFull = vbNameFull);

   -- ���� �� ������� �������� ��� <������ ��������>
   IF vbValue IS NULL
   THEN
       -- �������� ����� <�� ���������>
       vbValue:= inDefaultValue;

       -- ������� Id ��� Level1
       vbToolsId := (SELECT Object_ToolsWeighing_View.Id FROM Object_ToolsWeighing_View
                     WHERE Object_ToolsWeighing_View.Name = inLevel1
                       AND Object_ToolsWeighing_View.isLeaf = FALSE
                       AND Object_ToolsWeighing_View.ParentID IS NULL);

       IF COALESCE (vbToolsId, 0) = 0
       THEN
           -- ��������
           vbParentId:= gpInsertUpdate_Object_ToolsWeighing (ioId      := 0
                                                           , inCode    := 0
                                                           , inName    := inLevel1
                                                           , inNameUser:= inLevel1
                                                           , inValue   := ''
                                                           , inNameFull:= ''
                                                           , inParentId:= 0
                                                           , inSession := inSession
                                                            );
       ELSE
           vbParentId:= vbToolsId;
       END IF;


       -- Level2
       IF TRIM (COALESCE (inLevel2, '')) <> ''
       THEN
           -- ������� Id ��� Level2
           vbToolsId := (SELECT Object_ToolsWeighing_View.Id FROM Object_ToolsWeighing_View
                         WHERE Object_ToolsWeighing_View.Name = inLevel2
                           AND Object_ToolsWeighing_View.isLeaf = FALSE
                           AND Object_ToolsWeighing_View.ParentID = vbParentId);

           IF COALESCE (vbToolsId, 0) = 0
           THEN
               -- ��������
               vbParentId:= gpInsertUpdate_Object_ToolsWeighing (ioId      := 0
                                                               , inCode    := 0
                                                               , inName    := inLevel2
                                                               , inNameUser:= inLevel2
                                                               , inValue   := ''
                                                               , inNameFull:= ''
                                                               , inParentId:= vbParentId
                                                               , inSession := inSession
                                                                );
           ELSE
               vbParentId:= vbToolsId;
           END IF;
       END IF;

       -- Level3
       IF TRIM (COALESCE (inLevel3, '')) <> ''
       THEN
           -- ������� Id ��� Level2
           vbToolsId := (SELECT Object_ToolsWeighing_View.Id FROM Object_ToolsWeighing_View
                         WHERE Object_ToolsWeighing_View.Name = inLevel3
                           AND Object_ToolsWeighing_View.isLeaf = FALSE
                           AND Object_ToolsWeighing_View.ParentID = vbParentId);

           IF COALESCE (vbToolsId, 0) = 0
           THEN
               -- ��������
               vbParentId:= gpInsertUpdate_Object_ToolsWeighing (ioId      := 0
                                                               , inCode    := 0
                                                               , inName    := inLevel3
                                                               , inNameUser:= inLevel3
                                                               , inValue   := ''
                                                               , inNameFull:= ''
                                                               , inParentId:= vbParentId
                                                               , inSession := inSession
                                                                );
           ELSE
               vbParentId:= vbToolsId;
           END IF;
       END IF;


       -- �������� inItemName
       vbToolsId:= gpInsertUpdate_Object_ToolsWeighing (ioId      := 0
                                                      , inCode    := 0
                                                      , inName    := inItemName
                                                      , inNameUser:= inItemName
                                                      , inValue   := inDefaultValue
                                                      , inNameFull:= vbNameFull
                                                      , inParentId:= vbParentId
                                                      , inSession := inSession
                                                       );
    END IF;

    -- ������� ��������
    RETURN (vbValue);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_ToolsWeighing_Value (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.01.15                                        * all
 14.03.14                                                         * change result to table
 13.03.14                                                         *
*/

-- ����
-- SELECT * FROM gpGet_ToolsWeighing_Value ('Scale_1', 'Movement', 'MovementDesc_1', '', '98751', '2');
