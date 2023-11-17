 -- Function: gpInsertUpdate_Object_GoodsGroup_UKTZED_byName_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup_UKTZED2_From_Excel (TVarChar, TVarChar, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup_UKTZED_byName_Load (TVarChar, TVarChar, TVarChar, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup_UKTZED_byName_Load(
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



     -- ��������
     IF 1 < (SELECT Object.Id
             FROM Object
                 LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                      ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                     AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                 LEFT JOIN Object AS GoodsGroup ON GoodsGroup.Id = ObjectLink_GoodsGroup.ChildObjectId
             WHERE Object.DescId = zc_object_GoodsGroup()
               AND           TRIM (Object.ValueData)          ILIKE TRIM (inGoodsGroupName)
               AND COALESCE (TRIM (GoodsGroup.ValueData), '') ILIKE TRIM (inParentName)
            )
        AND 1=0
     THEN
         RAISE EXCEPTION '������.������� ��������� �������� ������ = <%> � ������� = <%>', inGoodsGroupName, inParentName;
     END IF;

     -- �������� ��� ���� ���� ������ ����
     vbGoodsGroupId := (SELECT Object.Id
                        FROM Object
                            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                                 ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                                AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                            LEFT JOIN Object AS GoodsGroup ON GoodsGroup.Id = ObjectLink_GoodsGroup.ChildObjectId
                        WHERE Object.DescId = zc_object_GoodsGroup()
                          AND           TRIM (Object.ValueData)          ILIKE TRIM (inGoodsGroupName)
                          AND COALESCE (TRIM (GoodsGroup.ValueData), '') ILIKE TRIM (inParentName)
                        LIMIT 1
                       );


     -- ��������
     IF COALESCE (vbGoodsGroupId,0) = 0
     THEN
        RAISE EXCEPTION '������.�� ������� ������ = <%> � ������� = <%>.', inGoodsGroupName, inParentName;
     END IF;

     -- �������� ���� ����� ��� ��� ������
     IF EXISTS (SELECT 1
                FROM ObjectString
                WHERE ObjectString.DescId = zc_ObjectString_GoodsGroup_UKTZED_new()
                  AND ObjectString.ObjectId = vbGoodsGroupId
                  AND COALESCE (ObjectString.ValueData, '') <> ''
               )
        AND 1=0
     THEN
         RAISE EXCEPTION '������. ��� ������ = <%> � ������� = <%>, ����� ��� UKTZED ��� ����������.(%)', inGoodsGroupName, inParentName, vbGoodsGroupId;
     END IF;

 
      -- ��������� ��������
      PERFORM lpInsert_ObjectProtocol (Object.Id, vbUserId)
      FROM (SELECT Object.Id
                 , lpInsertUpdate_ObjectString (zc_ObjectString_GoodsGroup_UKTZED_new(), Object.Id, TRIM (inCodeUKTZED_new))
                 , lpInsertUpdate_ObjectDate (zc_ObjectDate_GoodsGroup_UKTZED_new(), Object.Id, inDateUKTZED_new)
            FROM Object
                LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                     ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                    AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                LEFT JOIN Object AS GoodsGroup ON GoodsGroup.Id = ObjectLink_GoodsGroup.ChildObjectId
            WHERE Object.DescId = zc_object_GoodsGroup()
              AND           TRIM (Object.ValueData)          ILIKE TRIM (inGoodsGroupName)
              AND COALESCE (TRIM (GoodsGroup.ValueData), '') ILIKE TRIM (inParentName)
           ) AS Object;



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
-- select * from gpInsertUpdate_Object_GoodsGroup_UKTZED_byName_Load( '����' ::TVarChar, '����� ��������':: TVarChar, '5555xcsxcsc'::TVarChar,'15.11.2023' ::TDateTime, '9457'::TVarChar)
