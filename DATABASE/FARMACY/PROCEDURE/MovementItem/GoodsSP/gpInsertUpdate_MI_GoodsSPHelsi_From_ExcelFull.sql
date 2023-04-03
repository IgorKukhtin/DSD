-- Function: gpInsertUpdate_MI_GoodsSPHelsi_From_ExcelFull()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsSPHelsi_From_ExcelFull (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_GoodsSPHelsi_From_ExcelFull(
    IN inOperDate            TDateTime ,    -- 
    IN inColSP               Integer    ,   -- � �/� 

    IN inMedicalProgramSPId  TVarChar  ,    -- ����������� ��������� (A)

    IN inCountSPMin          TVarChar  ,    -- ̳������� ������� ���� ������� �� ������� (AW)
    IN inCountSP             TVarChar  ,    -- ʳ������ ������� ���������� ������ � ��������� �������� (���. ������) (AX)

    IN inPriceSP             TVarChar  ,    -- ���������� ���� �� ��, ��� (���. ������) (BJ)
    IN inPriceOptSP          TVarChar  ,    -- ������-�������� ���� �� ��������. ��� (BG)
    IN inPriceRetSP          TVarChar  ,    -- �������� ���� �� ��������. ��� (BH)
    IN inDailyCompensationSP TVarChar  ,    -- ����� ������������ ������ ���� ���������� ������. ��� (BI)
    IN inPaymentSP           TVarChar  ,    -- ���� ������� �� ��������. ��� (BK)


    IN inDenumeratorValue    TVarChar  ,    -- ʳ������ ������� (AI)

    IN inReestrDateSP        TVarChar  ,    -- ���� ��������� ������ 䳿 ������������� ���������� �� ��������� ���� (BB)
    IN inPack                TVarChar  ,    -- ��������� (F)
    IN inIntenalSPName       TVarChar  ,    -- ̳�������� ������������� ����� (���. ������) (D)
    IN inIntenalSPName_Lat   TVarChar  ,    -- ̳�������� ������������� ����� (���. ������) (E)
    IN inBrandSPName         TVarChar  ,    -- ����������� ����� ���������� ������ (���. ������) (AV)
    IN inKindOutSPName       TVarChar  ,    -- ����� ������� (���. ������) (I)

    IN inMakerSP             TVarChar  ,    -- ������������ ���������, ����� (AY)
    IN inCountry             TVarChar  ,    -- ������������ ���������, ����� (AZ)
    IN inReestrSP            TVarChar  ,    -- ����� ������������� ���������� �� ��������� ���� (BA) 


    IN inIdSP                TVarChar  ,    -- ID ����. ������ (AQ)
    
    IN inProgramId           TVarChar  ,    -- ID �������� �������� (BF)
    IN inNumeratorUnit       TVarChar  ,    -- ������� ����� ���� 䳿 (AH)
    IN inDenumeratorUnit     TVarChar  ,    -- ������� ����� ������� (AU)
    
    IN inName                TVarChar  ,    -- �������� (AF)
    
    IN inEndDate             TVarChar  ,    -- ���� ��������� (BM)

    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbValue TFloat;

   DECLARE vbKindOutSPId Integer;
   DECLARE vbIntenalSPId Integer;
   DECLARE vbBrandSPId Integer;
   DECLARE vbIntenalSPName TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
     
     IF TRIM(inMedicalProgramSPId) = '' THEN RETURN; END IF;     
     
     IF inEndDate <> ''
     THEN
       IF inEndDate::TDateTime < inOperDate THEN RETURN; END IF;     
     END IF;
     
     -- ���� ��� ������� Movement ��
     IF NOT EXISTS(SELECT Movement.Id
                   FROM Movement
                        INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                ON MovementDate_OperDateStart.MovementId = Movement.Id
                                               AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                               AND MovementDate_OperDateStart.ValueData  <= date_trunc('DAY', inOperDate)

                        INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                               AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                               AND MovementDate_OperDateEnd.ValueData  >= date_trunc('DAY', inOperDate)

                        INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                                      ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                                     AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
                        INNER JOIN ObjectString AS ObjectString_ProgramId 	
                                                ON ObjectString_ProgramId.ObjectId = MLO_MedicalProgramSP.ObjectId
                                               AND ObjectString_ProgramId.DescId = zc_ObjectString_MedicalProgramSP_ProgramId()
                                               AND ObjectString_ProgramId.ValueData ILIKE TRIM(inMedicalProgramSPId)

                   WHERE Movement.DescId = zc_Movement_GoodsSP()
                     AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete()))
     THEN
       SELECT gpInsertUpdate_Movement_GoodsSP(ioId                  := 0, -- ���� ������� <�������� ��������>
                                              inInvNumber           := CAST (NEXTVAL ('Movement_GoodsSP_seq') AS TVarChar), -- ����� ���������
                                              inOperDate            := date_trunc('DAY', inOperDate), -- ���� ���������
                                              inOperDateStart       := date_trunc('DAY', inOperDate), --
                                              inOperDateEnd         := date_trunc('DAY', inOperDate), --
                                              inMedicalProgramSPId  := MLO_MedicalProgramSP.ObjectId , --
                                              inPercentMarkup       := MovementFloat_PercentMarkup.ValueData, --
                                              inPercentPayment      := MovementFloat_PercentPayment.ValueData, --
                                              inSession             := inSession    -- ������ ������������     
                                              )
       INTO vbMovementId
       FROM Movement

            INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                          ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                         AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
            INNER JOIN ObjectString AS ObjectString_ProgramId 	
                                    ON ObjectString_ProgramId.ObjectId = MLO_MedicalProgramSP.ObjectId
                                   AND ObjectString_ProgramId.DescId = zc_ObjectString_MedicalProgramSP_ProgramId()
                                   AND ObjectString_ProgramId.ValueData ILIKE TRIM(inMedicalProgramSPId)

            LEFT JOIN MovementFloat AS MovementFloat_PercentMarkup
                                    ON MovementFloat_PercentMarkup.MovementId = Movement.Id
                                   AND MovementFloat_PercentMarkup.DescId = zc_MovementFloat_PercentMarkup()

            LEFT JOIN MovementFloat AS MovementFloat_PercentPayment
                                    ON MovementFloat_PercentPayment.MovementId = Movement.Id
                                   AND MovementFloat_PercentPayment.DescId = zc_MovementFloat_PercentPayment()

       WHERE Movement.DescId = zc_Movement_GoodsSP()
         AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
       ORDER BY Movement.OperDate DESC
       LIMIT 1;
     ELSE
       SELECT Movement.Id
       INTO vbMovementId
       FROM Movement
            INNER JOIN MovementDate AS MovementDate_OperDateStart
                                    ON MovementDate_OperDateStart.MovementId = Movement.Id
                                   AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                   AND MovementDate_OperDateStart.ValueData  <= date_trunc('DAY', inOperDate)

            INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                    ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                   AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                   AND MovementDate_OperDateEnd.ValueData  >= date_trunc('DAY', inOperDate)

            INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                          ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                         AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
            INNER JOIN ObjectString AS ObjectString_ProgramId 	
                                    ON ObjectString_ProgramId.ObjectId = MLO_MedicalProgramSP.ObjectId
                                   AND ObjectString_ProgramId.DescId = zc_ObjectString_MedicalProgramSP_ProgramId()
                                   AND ObjectString_ProgramId.ValueData ILIKE TRIM(inMedicalProgramSPId)

       WHERE Movement.DescId = zc_Movement_GoodsSP()
         AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete());     
     END IF;
     
     -- ��������� Movement ��
     IF COALESCE (vbMovementId, 0) <> 0
     THEN
       IF EXISTS(SELECT Movement.Id
                 FROM Movement
                 WHERE Movement.DescId = zc_Movement_GoodsSP()
                   AND Movement.Id = vbMovementId
                   AND Movement.StatusId = zc_Enum_Status_Complete())
       THEN
         RAISE EXCEPTION '�������� ��� ����������� ��������� <%> % ��������.%������������ ���.', inMedicalProgramSPId, 
               (SELECT Movement.InvNumber
                 FROM Movement
                 WHERE Movement.DescId = zc_Movement_GoodsSP()
                   AND Movement.Id = vbMovementId
                   AND Movement.StatusId = zc_Enum_Status_Complete()), Chr(13);     
       END IF;             
     ELSE
       RAISE EXCEPTION '�������� ��� ����������� ��������� <%> �� ������.', inMedicalProgramSPId;     
     END IF;
     
     -- �������� ����� "̳�������� ������������� ����� (���. ������)" 
     -- ���� �� ������� ��������� ����� ������� � ����������
     vbIntenalSPName := TRIM (inIntenalSPName)||', '||TRIM (inIntenalSPName_Lat); --������� ��� � ���. �������� ����� ���.
     vbIntenalSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_IntenalSP() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(vbIntenalSPName)) LIMIT 1);
     IF COALESCE (vbIntenalSPId, 0) = 0 AND COALESCE (vbIntenalSPName, '') <> '' THEN
        -- ���������� ����� �������
        vbIntenalSPId := gpInsertUpdate_Object_IntenalSP (ioId     := 0
                                                        , inCode   := lfGet_ObjectCode(0, zc_Object_IntenalSP()) 
                                                        , inName   := TRIM(vbIntenalSPName)
                                                        , inSession:= inSession
                                                          );
     END IF;   

     -- �������� ����� "����������� ����� ���������� ������ (���. ������)"
     -- ���� �� ������� ��������� ����� ������� � ����������
     vbKindOutSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_KindOutSP() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inKindOutSPName)) LIMIT 1);
     IF COALESCE (vbKindOutSPId, 0) = 0 AND COALESCE (inKindOutSPName, '')<> '' THEN
        -- ���������� ����� �������
        vbKindOutSPId := gpInsertUpdate_Object_KindOutSP (ioId     := 0
                                                        , inCode   := lfGet_ObjectCode(0, zc_Object_KindOutSP()) 
                                                        , inName   := TRIM(inKindOutSPName)
                                                        , inSession:= inSession
                                                          );
     END IF; 

     -- �������� ����� "����� ������� (���. ������)"
     -- ���� �� ������� ��������� ����� ������� � ����������
     vbBrandSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_BrandSP() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inBrandSPName)) LIMIT 1);
     IF COALESCE (vbBrandSPId, 0) = 0 AND COALESCE (inBrandSPName, '')<> '' THEN
        -- ���������� ����� �������
        vbBrandSPId := gpInsertUpdate_Object_BrandSP (ioId     := 0
                                                    , inCode   := lfGet_ObjectCode(0, zc_Object_BrandSP()) 
                                                    , inName   := TRIM(inBrandSPName)
                                                    , inSession:= inSession
                                                     );
     END IF; 

     -- ���� Id ������
     SELECT MovementItem.Id
     INTO vbId
     FROM MovementItem
          LEFT JOIN MovementItemString AS MIString_IdSP
                                       ON MIString_IdSP.MovementItemId = MovementItem.Id
                                      AND MIString_IdSP.DescId = zc_MIString_IdSP()
     WHERE MovementItem.MovementId = vbMovementId
       AND MIString_IdSP.ValueData = inIdSP
     Limit 1; -- �� ������ ������
     
     -- ���� Id ������ ���� ����
     SELECT Object_Goods_Main.Id
     INTO vbGoodsId
     FROM Object_Goods_Main
     WHERE Object_Goods_Main.IdSP = inIdSP
     Limit 1; -- �� ������ ������
     
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (vbId, 0) = 0;

    -- ��������� <������� ���������>
    vbId := lpInsertUpdate_MovementItem (COALESCE(vbId, 0), zc_MI_Master(), COALESCE(vbGoodsId, 0), vbMovementId, 0, NULL);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ColSP(), vbId, inColSP);

    -- ��������� <>
    IF inCountSPMin <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inCountSPMin, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSPMin(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- ��������� <>
    IF inCountSP <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inCountSP, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSP(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- ��������� <>
    IF inPriceOptSP <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inPriceOptSP, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceOptSP(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- ��������� <>
    IF inPriceRetSP <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inPriceRetSP, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceRetSP(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- ��������� <>
    IF inDailyCompensationSP <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inDailyCompensationSP, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DailyCompensationSP(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- ��������� <>
    IF inPriceSP <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inPriceSP, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSP(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- ��������� <>
    IF inPaymentSP <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inPaymentSP, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PaymentSP(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- ��������� <>
    IF inDenumeratorValue <> ''
    THEN
      BEGIN  
        vbValue := REPLACE(inDenumeratorValue, ',', '.')::TFloat;
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DenumeratorValueSP(), vbId, vbValue);
      EXCEPTION WHEN others THEN vbValue := Null;
      END;
    END IF;     

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Pack(), vbId, TRIM(inPack));
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_MakerSP(), vbId, (TRIM(inMakerSP)||', '|| TRIM(inCountry)) ::TVarChar);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ReestrSP(), vbId, TRIM(inReestrSP));
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ReestrDateSP(), vbId, TRIM(inReestrDateSP));
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_IdSP(), vbId, TRIM(inIdSP));

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ProgramIdSP(), vbId, TRIM(inProgramId));
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_NumeratorUnitSP(), vbId, TRIM(inNumeratorUnit));
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_DenumeratorUnitSP(), vbId, TRIM(inDenumeratorUnit));    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Name(), vbId, TRIM(inName));

    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_IntenalSP(), vbId, vbIntenalSPId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BrandSP(), vbId, vbBrandSPId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_KindOutSP(), vbId, vbKindOutSPId);


    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);    
   
    -- !!!�������� ��� �����!!!
/*    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> <%> <%> <%> <%>', vbMovementId, vbIsInsert, vbId, vbGoodsId, inSession;
    END IF;*/
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.11.22                                                       *
*/

-- ����
/* SELECT * FROM gpInsertUpdate_MI_GoodsSPHelsi_From_ExcelFull(
     inOperDate            := '01.12.2022',
     inColSP               := 760,    -- � �/� 

     inMedicalProgramSPId  := 'e9c6beeb-b19f-4b97-b42a-020c5c996c56',    -- ����������� ��������� (A)

     inCountSPMin          := '1',    -- ̳������� ������� ���� ������� �� ������� (AW)
     inCountSP             := '5',    -- ʳ������ ������� ���������� ������ � ��������� �������� (���. ������) (AX)

     inPriceSP             := '1740.2',    -- ���������� ���� �� ��, ��� (���. ������) (BJ)
     inPriceOptSP          := '1581.3',    -- ������-�������� ���� �� ��������. ��� (BG)
     inPriceRetSP          := '2047.3',    -- �������� ���� �� ��������. ��� (BH)
     inDailyCompensationSP := '69.608',    -- ����� ������������ ������ ���� ���������� ������. ��� (BI)
     inPaymentSP           := '307.1',    -- ���� ������� �� ��������. ��� (BK)
     inDenumeratorValue    := '1',    -- ʳ������ ������� (AT)

     inReestrDateSP        := '2100-01-01'  ,    -- ���� ��������� ������ 䳿 ������������� ���������� �� ��������� ���� (BB)
     inPack                := '300'  ,    -- ��������� (F)
     inIntenalSPName       := '������ ������'  ,    -- ̳�������� ������������� ����� (���. ������) (D)
     inIntenalSPName_Lat   := 'Insulin detemir'  ,    -- ̳�������� ������������� ����� (���. ������) (E)
     inBrandSPName         := '����̲Ю �������ͮ'  ,    -- ����������� ����� ���������� ������ (���. ������) (AV)
     inKindOutSPName       := 'SYRINGE_PEN'  ,    -- ����� ������� (���. ������) (I)

     inMakerSP             := '�/� ���� ������'  ,    -- ������������ ���������, ����� (AY)
     inCountry             := '����'  ,    -- ������������ ���������, ����� (AZ)
     inReestrSP            := 'UA/4858/01/01'  ,    -- ����� ������������� ���������� �� ��������� ���� (BA) 
     inIdSP                := 'dd2681b8-4476-4c14-886a-14fe0aecd736'  ,    -- ID ����. ������ (AQ)
    
     inProgramId           := 'f4528123-ce19-4a6a-abbe-7ccc13914136'  ,    -- ID �������� �������� (BF)
     inNumeratorUnit       := 'IU'  ,    -- ������� ����� ���� 䳿 (AH)
     inDenumeratorUnit     := 'SYRINGE_PEN'  ,    -- ������� ����� ������� (AU)
    
     inName                := '����̲Ю �������ͮ �������� ����������� � ���������� �����-����� 3 ��, 100 ��/��, ������� 䳿'  ,    -- �������� (AF)
     
     inEndDate             := '' , -- ���� ���������


     inSession := '3');*/
     
     
select * from gpInsertUpdate_MI_GoodsSPHelsi_From_ExcelFull(inOperDate := ('01.08.2023')::TDateTime , inColSP := 7500 , inMedicalProgramSPId := '1318eabc-1a1a-42f6-8450-61e11c19eede' , inCountSPMin := '100' , inCountSP := '100' , inPriceSP := '0.0' , inPriceOptSP := '0' , inPriceRetSP := '' , inDailyCompensationSP := '' , inPaymentSP := '' , inDenumeratorValue := '1.0' , inReestrDateSP := '2024-02-05' , inPack := '70.0' , inIntenalSPName := '������' , inIntenalSPName_Lat := 'Ethanol' , inBrandSPName := '����� �������� 70 %' , inKindOutSPName := 'SOLUTION' , inMakerSP := '"�� \"���������\""' , inCountry := 'UA' , inReestrSP := 'UA/17228/01/01' , inIdSP := 'df125d7e-35e5-4c6a-9c99-45fe1efc1163' , inProgramId := '525df984-65be-4ae7-a18d-d662642a8acb' , inNumeratorUnit := 'PERCENT' , inDenumeratorUnit := 'FLACON' , inName := '������ 70 �������/��, ������' , inEndDate := '' ,  inSession := '3');