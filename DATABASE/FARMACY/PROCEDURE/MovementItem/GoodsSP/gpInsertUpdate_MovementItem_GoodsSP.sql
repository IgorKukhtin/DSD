-- Function: gpInsert_MovementItem_GoodsSP()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsSP (Integer, Integer,  Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           , TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_GoodsSP(
 INOUT ioId                   Integer   , -- ���� ������
    IN inMovementId           Integer   ,
    IN inGoodsId              Integer   , -- ������
    IN inIntenalSPId          Integer ,
    IN inBrandSPId            Integer ,
    IN inKindOutSPId          Integer ,
    IN inColSP                TFloat  ,
    IN inCountSPMin           TFloat  ,
    IN inCountSP              TFloat  ,
    IN inPriceOptSP           TFloat  ,
    IN inPriceRetSP           TFloat  ,
    IN inDailyNormSP          TFloat  ,
    IN inDailyCompensationSP  TFloat  ,
    IN inPriceSP              TFloat  ,
    IN inPaymentSP            TFloat  ,
    IN inGroupSP              TFloat  ,

    IN inDenumeratorValueSP   TFloat  ,

    IN inPack                 TVarChar,
    IN inCodeATX              TVarChar,
    IN inMakerSP              TVarChar,
    IN inReestrSP             TVarChar,
    IN inReestrDateSP         TVarChar,
    IN inIdSP                 TVarChar  ,    --
    IN inDosageIdSP           TVarChar  ,    --

    IN inProgramIdSP          TVarChar  ,    --
    IN inNumeratorUnitSP      TVarChar  ,    --
    IN inDenumeratorUnitSP    TVarChar  ,    --

    IN inSession              TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbOperDateStart TDateTime;
   DECLARE vbOperDateEnd TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    IF COALESCE (inIdSP, '') = '' OR length(inIdSP) <> 36
    THEN
      RAISE EXCEPTION '�� ��������� <ID ����. ������> ��� ������������ ������ <%>', inIdSP;
    END IF;
    

    IF COALESCE (ioId, 0) <> 0 AND
       COALESCE (inIdSP, '') <> COALESCE ((SELECT MovementItemString.ValueData 
                                           FROM MovementItemString 
                                           WHERE MovementItemString.MovementItemID = ioId
                                             AND MovementItemString.DescId = zc_MIString_IdSP()), '')
    THEN
      RAISE EXCEPTION '��������� <ID ����. ������> ���������.';
    END IF;
    
    vbGoodsId := COALESCE ((SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.ID = ioId), 0);
    
    IF COALESCE (inGoodsId, 0) <> COALESCE (vbGoodsId, 0)
    THEN

       SELECT MovementDate_OperDateStart.ValueData
            , MovementDate_OperDateEnd.ValueData
       INTO vbOperDateStart, vbOperDateEnd
       FROM Movement
            INNER JOIN MovementDate AS MovementDate_OperDateStart
                                    ON MovementDate_OperDateStart.MovementId = Movement.Id
                                   AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()

            INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                    ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                   AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()

       WHERE Movement.DescId = zc_Movement_GoodsSP()
         AND Movement.Id = inMovementId;
    
      IF COALESCE ((vbGoodsId), 0) <> 0
      THEN
        PERFORM gpUpdate_Goods_IdSP_Del(inGoodsMainId := vbGoodsId, inIdSP := inIdSP, inSession := inSession); 

        UPDATE MovementItem SET ObjectId = 0
        WHERE MovementItem.ID IN
           (SELECT MovementItem.ID
            FROM Movement
                 INNER JOIN MovementDate AS MovementDate_OperDateStart
                                         ON MovementDate_OperDateStart.MovementId = Movement.Id
                                        AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                        AND MovementDate_OperDateStart.ValueData  >= vbOperDateStart

                 INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                         ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                        AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                        AND MovementDate_OperDateEnd.ValueData  <= vbOperDateEnd

                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = FALSE
                                        AND COALESCE (MovementItem.ObjectId, 0) <> 0

                 -- ID ���������� ������
                 INNER JOIN MovementItemString AS MIString_IdSP
                                               ON MIString_IdSP.MovementItemId = MovementItem.Id
                                              AND MIString_IdSP.DescId = zc_MIString_IdSP()
                                              AND MIString_IdSP.ValueData = inIdSP

            WHERE Movement.DescId = zc_Movement_GoodsSP()
              AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
              AND Movement.Id <> inMovementId);

      END IF;
      
      IF COALESCE (inGoodsId, 0) <> 0 THEN 
        PERFORM gpUpdate_Goods_IdSP_Add(inGoodsMainId := inGoodsId , inIdSP := inIdSP,  inSession := inSession); 
        
        UPDATE MovementItem SET ObjectId = inGoodsId
        WHERE MovementItem.ID IN
           (SELECT MovementItem.ID
            FROM Movement
                 INNER JOIN MovementDate AS MovementDate_OperDateStart
                                         ON MovementDate_OperDateStart.MovementId = Movement.Id
                                        AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                        AND MovementDate_OperDateStart.ValueData  >= vbOperDateStart

                 INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                         ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                        AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                        AND MovementDate_OperDateEnd.ValueData  <= vbOperDateEnd

                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = FALSE
                                        AND COALESCE (MovementItem.ObjectId, 0) <> inGoodsId

                 -- ID ���������� ������
                 INNER JOIN MovementItemString AS MIString_IdSP
                                               ON MIString_IdSP.MovementItemId = MovementItem.Id
                                              AND MIString_IdSP.DescId = zc_MIString_IdSP()
                                              AND MIString_IdSP.ValueData = inIdSP

            WHERE Movement.DescId = zc_Movement_GoodsSP()
              AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
              AND Movement.Id <> inMovementId);
      END IF;
    END IF;
       
    -- ��������� ������
    ioId := lpInsertUpdate_MovementItem_GoodsSP (ioId                  := COALESCE(ioId,0)
                                               , inMovementId          := inMovementId
                                               , inGoodsId             := inGoodsId
                                               , inIntenalSPId         := inIntenalSPId
                                               , inBrandSPId           := inBrandSPId
                                               , inKindOutSPId         := inKindOutSPId
                                               , inColSP               := inColSP
                                               , inCountSPMin          := inCountSPMin
                                               , inCountSP             := inCountSP
                                               , inPriceOptSP          := inPriceOptSP
                                               , inPriceRetSP          := inPriceRetSP
                                               , inDailyNormSP         := inDailyNormSP
                                               , inDailyCompensationSP := inDailyCompensationSP
                                               , inPriceSP             := inPriceSP
                                               , inPaymentSP           := inPaymentSP
                                               , inGroupSP             := inGroupSP
                                               , inDenumeratorValueSP  := inDenumeratorValueSP
                                               , inPack                := inPack
                                               , inCodeATX             := inCodeATX
                                               , inMakerSP             := inMakerSP
                                               , inReestrSP            := inReestrSP
                                               , inReestrDateSP        := inReestrDateSP
                                               , inIdSP                := inIdSP
                                               , inDosageIdSP          := inDosageIdSP
                                               , inProgramIdSP         := inProgramIdSP
                                               , inNumeratorUnitSP     := inNumeratorUnitSP
                                               , inDenumeratorUnitSP   := inDenumeratorUnitSP
                                               , inUserId              := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.07.19         *
 22.04.19         * add IdSP, inDosageIdSP
 14.08.18         *
*/
--
