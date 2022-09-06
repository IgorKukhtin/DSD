-- Function: gpUpdate_Unit_SetDateRRO()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SetDateRRO(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SetDateRRO(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inSetDateRRO          TDateTime ,    -- ��������������� ��	
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDate TVarChar;
   DECLARE vbDateListOld TVarChar;
   DECLARE vbDateListNew TVarChar;
   DECLARE vbIndex Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   vbDate := zfConvert_DateToString (inSetDateRRO);
   vbDateListNew := '';
   
   vbDateListOld := COALESCE ((SELECT ObjectString_SetDateRROList.ValueData  
                               FROM ObjectString AS ObjectString_SetDateRROList
                               WHERE ObjectString_SetDateRROList.ObjectId = inId
                                 AND ObjectString_SetDateRROList.DescId = zc_ObjectString_Unit_SetDateRROList()), '');
   
   -- ������ ����
   vbIndex := 1;
   WHILE SPLIT_PART (vbDateListOld, ',', vbIndex) <> '' LOOP
        -- ��������� �� ��� �����
        IF SPLIT_PART (vbDateListOld, ',', vbIndex) <> vbDate
        THEN
          IF vbDateListNew <> ''
          THEN
            vbDateListNew := vbDateListNew||',';
          END IF;
          vbDateListNew := vbDateListNew||SPLIT_PART (vbDateListOld, ',', vbIndex);
        ELSE
          vbDate := '';
        END IF;
          
        -- ������ ����������
        vbIndex := vbIndex + 1;
   END LOOP;
   
   IF vbDate <> ''
   THEN
      IF vbDateListNew <> ''
      THEN
        vbDateListNew := vbDateListNew||',';
      END IF;
      vbDateListNew := vbDateListNew||vbDate;   
   END IF;

   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_SetDateRROList(), inId, vbDateListNew);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.09.22                                                       *
*/