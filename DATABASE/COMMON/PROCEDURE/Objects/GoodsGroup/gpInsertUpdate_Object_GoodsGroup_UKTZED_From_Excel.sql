 -- Function: gpInsertUpdate_Object_GoodsGroup_UKTZED_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup_UKTZED_From_Excel (Integer, TVarChar, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup_UKTZED_From_Excel (TVarChar, TVarChar, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup_UKTZED_From_Excel(
    IN inGoodsGroupName   TVarChar   ,
    IN inCodeUKTZED       TVarChar  , -- 
    IN inCodeUKTZED_new   TVarChar  ,
    IN inDateUKTZED_new   TDateTime ,
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpGetUserBySession (inSession); 
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroup());

     --��������
     IF COALESCE (inCodeUKTZED,'') = ''
     THEN
         RAISE EXCEPTION '������. ��� UKTZED �� ����� ��� <%>.', inGoodsGroupName;
     END IF;

     --��������
     IF COALESCE (inCodeUKTZED_new,'') = ''
     THEN
         RAISE EXCEPTION '������. ����� ��� UKTZED �� ����� ��� <%>.', inGoodsGroupName; 
     END IF;

          -- ��������
     IF NOT EXISTS (SELECT 1 
                    FROM ObjectString
                    WHERE ObjectString.DescId = zc_ObjectString_GoodsGroup_UKTZED()
                      AND TRIM (ObjectString.ValueData) = TRIM (inCodeUKTZED)
                    LIMIT 1)
     THEN
        RETURN;
        RAISE EXCEPTION '������.�� ������� ������ � ����� UKTZED = <%> .', inCodeUKTZED;
     END IF;

     --�������� ���� ����� ��� ��� ������ 
     IF EXISTS (SELECT 1
                FROM ObjectString
                     INNER JOIN ObjectString AS ObjectString_UKTZED_new
                                             ON ObjectString_UKTZED_new.ObjectId = ObjectString.ObjectId
                                            AND ObjectString_UKTZED_new.DescId = zc_ObjectString_GoodsGroup_UKTZED_new()
                                            AND COALESCE (ObjectString_UKTZED_new.ValueData, '') <> ''
                WHERE ObjectString.DescId = zc_ObjectString_GoodsGroup_UKTZED()
                  AND TRIM (ObjectString.ValueData) = TRIM (inCodeUKTZED)
                LIMIT 1) 
     THEN 
         RAISE EXCEPTION '������. ��� ������ <%> ����� ��� UKTZED ��� ����������.', inGoodsGroupName; 
     END IF;
     

     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsGroup_UKTZED_new(), ObjectString.ObjectId, TRIM (inCodeUKTZED_new))
           , lpInsertUpdate_ObjectDate (zc_ObjectDate_GoodsGroup_UKTZED_new(), ObjectString.ObjectId, inDateUKTZED_new)
     FROM ObjectString
     WHERE ObjectString.DescId = zc_ObjectString_GoodsGroup_UKTZED()
       AND TRIM (ObjectString.ValueData) = TRIM (inCodeUKTZED);
   
 
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
 13.11.23         *
*/

-- ����
--