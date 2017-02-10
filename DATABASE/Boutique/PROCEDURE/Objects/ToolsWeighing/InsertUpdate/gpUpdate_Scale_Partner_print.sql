-- Function: gpUpdate_Scale_Partner_print()

-- DROP FUNCTION IF EXISTS gpUpdate_Scale_Partner_print (Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Scale_Partner_print (Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_Partner_print(
    IN inPartnerId           Integer   , -- ���� ������� <��������>
    IN inIsMovement          Boolean   , 
    IN inIsAccount           Boolean   ,
    IN inIsTransport         Boolean   , 
    IN inIsQuality           Boolean   , 
    IN inIsPack              Boolean   , 
    IN inIsSpec              Boolean   , 
    IN inIsTax               Boolean   , 
    IN inCountMovement       TFloat    , -- ���������
    IN inCountAccount        TFloat    , -- ����
    IN inCountTransport      TFloat    , -- ���
    IN inCountQuality        TFloat    , -- ������������
    IN inCountPack           TFloat    , -- �����������
    IN inCountSpec           TFloat    , -- ������������
    IN inCountTax            TFloat    , -- ���������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbTmp Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     SELECT CASE WHEN ObjectLink_Juridical_Retail.ChildObjectId > 0
                      THEN lpInsertUpdate_Object_Retail_PrintKindItem (ioId         := ObjectLink_Juridical_Retail.ChildObjectId
                                                                     , inIsMovement := inIsMovement
                                                                     , inIsAccount  := inIsAccount
                                                                     , inIsTransport:= inIsTransport
                                                                     , inIsQuality  := inIsQuality
                                                                     , inIsPack     := inIsPack
                                                                     , inIsSpec     := inIsSpec
                                                                     , inIsTax      := inIsTax
                                                                     , inCountMovement   := inCountMovement
                                                                     , inCountAccount    := inCountAccount
                                                                     , inCountTransport  := inCountTransport
                                                                     , inCountQuality    := inCountQuality
                                                                     , inCountPack       := inCountPack
                                                                     , inCountSpec       := inCountSpec
                                                                     , inCountTax        := inCountTax
                                                                     , inUserId     := vbUserId
                                                                      )
                 ELSE lpInsertUpdate_Object_Juridical_PrintKindItem (ioId         := ObjectLink_Partner_Juridical.ChildObjectId
                                                                   , inIsMovement := inIsMovement
                                                                   , inIsAccount  := inIsAccount
                                                                   , inIsTransport:= inIsTransport
                                                                   , inIsQuality  := inIsQuality
                                                                   , inIsPack     := inIsPack
                                                                   , inIsSpec     := inIsSpec
                                                                   , inIsTax      := inIsTax
                                                                   , inCountMovement   := inCountMovement
                                                                   , inCountAccount    := inCountAccount
                                                                   , inCountTransport  := inCountTransport
                                                                   , inCountQuality    := inCountQuality
                                                                   , inCountPack       := inCountPack
                                                                   , inCountSpec       := inCountSpec
                                                                   , inCountTax        := inCountTax
                                                                   , inUserId     := vbUserId
                                                                    )
            END
            INTO vbTmp
     FROM ObjectLink AS ObjectLink_Partner_Juridical
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
     WHERE ObjectLink_Partner_Juridical.ObjectId = inPartnerId
       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical();


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 27.05.15                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Scale_Partner_print (inMovementId:= 0, inSession:= '2')
