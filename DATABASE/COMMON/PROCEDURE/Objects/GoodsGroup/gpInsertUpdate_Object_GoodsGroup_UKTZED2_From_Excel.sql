 -- Function: gpInsertUpdate_Object_GoodsGroup_UKTZED2_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup_UKTZED2_From_Excel (TVarChar, TVarChar, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup_UKTZED2_From_Excel(
    IN inGoodsGroupName   TVarChar   ,
    IN inParentName       TVarChar  , -- 
    IN inCodeUKTZED_new   TVarChar  ,
    IN inDateUKTZED_new   TDateTime ,
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsGroupId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpGetUserBySession (inSession); 
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroup());


     --��������
     IF COALESCE (inGoodsGroupName,'') = ''
     THEN
         RETURN;
     END IF;


     --��������
     IF COALESCE (inCodeUKTZED_new,'') = ''
     THEN
         RAISE EXCEPTION '������. ����� ��� UKTZED �� ����� ��� <%>.', inGoodsGroupName; 
     END IF;



     --������� ������ ������ �� �������� � �� ��������
     vbGoodsGroupId := (SELECT Object.Id
                        FROM Object
                            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                                 ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                                AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                            LEFT JOIN Object AS GoodsGroup ON GoodsGroup.Id = ObjectLink_GoodsGroup.ChildObjectId
                        WHERE Object.DescId = zc_object_GoodsGroup()
                          AND TRIM (UPPER (Object.ValueData)) = TRIM (UPPER (inGoodsGroupName))
                          AND COALESCE (TRIM (UPPER (GoodsGroup.ValueData)),'') = COALESCE (TRIM (UPPER (inParentName)),'')
                        LIMIT 1);
 

     -- ��������
     IF COALESCE (vbGoodsGroupId,0) = 0
     THEN
        RAISE EXCEPTION '������.�� ������� ������ <%> � ��������� = <%>.', inGoodsGroupName, inParentName;
     END IF;

     --�������� ���� ����� ��� ��� ������ 
     IF EXISTS (SELECT 1
                FROM ObjectString
                WHERE ObjectString.DescId = zc_ObjectString_GoodsGroup_UKTZED_new()
                  AND ObjectString.ObjectId = vbGoodsGroupId
                  AND COALESCE (ObjectString.ValueData, '') <> ''
                LIMIT 1) 
     THEN 
         RAISE EXCEPTION '������. ��� ������ <%>, �������� = <%>, ����� ��� UKTZED ��� ����������.', inGoodsGroupName, inParentName; 
     END IF;
     

     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsGroup_UKTZED_new(), vbGoodsGroupId, TRIM (inCodeUKTZED_new));
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_GoodsGroup_UKTZED_new(), vbGoodsGroupId, inDateUKTZED_new);
   
 
   IF vbUserId = 9457 OR vbUserId = 5
   THEN
         RAISE EXCEPTION '����. ��. <%>', inGoodsGroupName; 
   END IF;   
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.11.23         *
*/

-- ����
-- select * from gpInsertUpdate_Object_GoodsGroup_UKTZED2_From_Excel( '����' ::TVarChar, '����� ��������':: TVarChar, '5555xcsxcsc'::TVarChar,'15.11.2023' ::TDateTime, '9457'::TVarChar)  