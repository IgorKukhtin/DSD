-- Function: gpSelect_Object_GlobalMsg()

DROP FUNCTION IF EXISTS gpSelect_Object_GlobalMsg (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GlobalMsg(
    IN inIP          TVarChar,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (MovementId Integer, NPP Integer, MsgAddr TVarChar, MsgText TVarChar, ColorText_Addr Integer, Color_Addr Integer, ColorText_Text Integer, Color_Text Integer)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsMsg_PromoStateKind Boolean;
   DECLARE vbIsUserSigning1       Boolean;
   DECLARE vbIsUserSigning2       Boolean;
   DECLARE vbMovementId_1_Head    Integer;
   DECLARE vbCount_1_Head         Integer;
   DECLARE vbMovementId_2_Head    Integer;
   DECLARE vbCount_2_Head         Integer;
   DECLARE vbMovementId_1_Main    Integer;
   DECLARE vbCount_1_Main         Integer;
   DECLARE vbMovementId_2_Main    Integer;
   DECLARE vbCount_2_Main         Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
     vbUserId:= lpGetUserBySession (inSession);
     

     -- zc_Enum_Role_Admin + ����� ��������� + 
     vbIsMsg_PromoStateKind:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS UserRole_View WHERE UserRole_View.RoleId IN (zc_Enum_Role_Admin(), 876016 ) AND UserRole_View.UserId = vbUserId);
     
     -- Signing
     vbIsUserSigning1:= vbUserId IN (280164);  -- ��������� �.�.
     vbIsUserSigning2:= vbUserId IN (9463, 5); -- ������ �.�.


     -- ����� ���������
     IF 1=1 AND vbIsMsg_PromoStateKind = TRUE
     THEN
          SELECT 
                 -- 1.1.1. MovementId - ������ - �������� �� ����������
                 MIN (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Head()
                            AND MovementFloat_PromoStateKind.ValueData     = 1
                                THEN Movement_Promo.Id
                                ELSE 2147483000
                      END) AS MovementId_1_Head
                 -- 1.1.2. Count - ������ - �������� �� ����������
               , SUM (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Head()
                            AND MovementFloat_PromoStateKind.ValueData     = 1
                                THEN 1
                                ELSE 0
                      END) AS Count_1_Head
                 -- 1.2.1. MovementId - �� ������ - �������� �� ����������
               , MIN (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Head()
                            AND COALESCE (MovementFloat_PromoStateKind.ValueData, 0) <> 1
                                THEN Movement_Promo.Id
                                ELSE 2147483000
                      END) AS MovementId_2_Head
                 -- 1.2.2. Count - �� ������ - �������� �� ����������
               , SUM (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Head()
                            AND COALESCE (MovementFloat_PromoStateKind.ValueData, 0) <> 1
                                THEN 1
                                ELSE 0
                      END) AS Count_2_Head


                 -- 2.1.1. MovementId - ������ - �������������� ��������
               , MIN (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Main()
                            AND MovementFloat_PromoStateKind.ValueData     = 1
                                THEN Movement_Promo.Id
                                ELSE 2147483000
                      END) AS MovementId_1_Main
                 -- 2.1.2. Count - ������ - �������������� ��������
               , SUM (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Main()
                            AND MovementFloat_PromoStateKind.ValueData     = 1
                                THEN 1
                                ELSE 0
                      END) AS Count_1_Main
                      
                 -- 2.2.1. MovementId - �� ������ - �������������� ��������
               , MIN (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Main()
                            AND COALESCE (MovementFloat_PromoStateKind.ValueData, 0) <> 1
                                THEN Movement_Promo.Id
                                ELSE 2147483000
                      END) AS MovementId_2_Main
                 -- 2.2.2. Count - �� ������ - �������������� ��������
               , SUM (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Main()
                            AND COALESCE (MovementFloat_PromoStateKind.ValueData, 0) <> 1
                                THEN 1
                                ELSE 0
                      END) AS Count_2_Main


                 INTO vbMovementId_1_Head
                    , vbCount_1_Head
                    , vbMovementId_2_Head
                    , vbCount_2_Head
                    , vbMovementId_1_Main
                    , vbCount_1_Main
                    , vbMovementId_2_Main
                    , vbCount_2_Main

          FROM Movement AS Movement_Promo
               -- � ������ �������� �� ���������� + � ������ �������������� ��������
               INNER JOIN MovementLinkObject AS MovementLinkObject_PromoStateKind
                                             ON MovementLinkObject_PromoStateKind.MovementId = Movement_Promo.Id
                                            AND MovementLinkObject_PromoStateKind.DescId     = zc_MovementLinkObject_PromoStateKind()
                                            AND MovementLinkObject_PromoStateKind.ObjectId   IN (zc_Enum_PromoStateKind_Head(), zc_Enum_PromoStateKind_Main())
               -- ������
               LEFT JOIN MovementFloat AS MovementFloat_PromoStateKind
                                       ON MovementFloat_PromoStateKind.MovementId = Movement_Promo.Id
                                      AND MovementFloat_PromoStateKind.DescId     = zc_MovementFloat_PromoStateKind()
               LEFT JOIN MovementDate AS MovementDate_StartSale
                                      ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                     AND MovementDate_StartSale.DescId     = zc_MovementDate_StartSale()
          WHERE Movement_Promo.DescId   = zc_Movement_Promo()
            AND Movement_Promo.StatusId = zc_Enum_Status_UnComplete()
            AND Movement_Promo.OperDate BETWEEN CURRENT_DATE - INTERVAL '5 MONTH' AND CURRENT_DATE + INTERVAL '25 MONTH'
            AND MovementDate_StartSale.ValueData >= CURRENT_DATE - INTERVAL '7 DAY'
         ;
     END IF;


     -- ���������
     RETURN QUERY
       -- 1.1.
       SELECT CASE WHEN vbCount_1_Head > 0
                        THEN vbMovementId_1_Head
                   WHEN vbCount_2_Head > 0
                        THEN vbMovementId_2_Head
                   ELSE -1
              END :: Integer AS MovementId

            , CASE WHEN vbIsUserSigning2 = TRUE THEN 3 ELSE 1 END :: Integer AS NPP
            , '��������� �� ���������� : ' :: TVarChar AS MsgAddr
            
            , (CASE WHEN vbCount_1_Head > 0
                        THEN '������������ ���������� ��� ���������� '
                          || ' : '    || vbCount_1_Head :: TVarChar || ' ��.'
                          || COALESCE ((SELECT ' <' || MIS.ValueData || '>' FROM MovementItem AS MI JOIN MovementItemString AS MIS ON MIS.MovementItemId = MI.Id AND MIS.DescId = zc_MIString_Comment() AND MIS.ValueData <> '' WHERE MI.MovementId = vbMovementId_1_Head AND MI.DescId = zc_MI_Message() AND MI.ObjectId = zc_Enum_PromoStateKind_Head() AND MI.isErased = FALSE ORDER BY MI.Id DESC LIMIT 1), '')
                          || '    � ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_1_Head)
                          || ' �� '   || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_1_Head))
                          || ' ������ ������ � ' || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_1_Head AND MD.DescId = zc_MovementDate_StartSale()))
                          || ' �� '              || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_1_Head AND MD.DescId = zc_MovementDate_EndSale()))
                    ELSE '��� ������������ ����������'
               END :: TVarChar
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_1_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Black()
                   WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_1_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Yelow()
                   WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Pink()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_1_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_1_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Yelow()
                   ELSE -1
              END AS Color_Text

      UNION ALL
       -- 1.2.
       SELECT CASE WHEN vbCount_2_Head > 0
                        THEN vbMovementId_2_Head
                   ELSE -1
              END :: Integer AS MovementId

            , CASE WHEN vbIsUserSigning2 = TRUE THEN 4 ELSE 2 END :: Integer AS NPP
            , '' :: TVarChar AS MsgAddr
            , (CASE WHEN vbCount_2_Head > 0
                        THEN '������������ ��������� ��� ���������� '
                          || ' : '    || vbCount_2_Head :: TVarChar || ' ��.'
                          || COALESCE ((SELECT ' <' || MIS.ValueData || '>' FROM MovementItem AS MI JOIN MovementItemString AS MIS ON MIS.MovementItemId = MI.Id AND MIS.DescId = zc_MIString_Comment() AND MIS.ValueData <> '' WHERE MI.MovementId = vbMovementId_2_Head AND MI.DescId = zc_MI_Message() AND MI.ObjectId = zc_Enum_PromoStateKind_Head() AND MI.isErased = FALSE ORDER BY MI.Id DESC LIMIT 1), '')
                          || '    � ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_2_Head)
                          || ' �� '   || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_2_Head))
                          || ' ������ ������ � ' || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_2_Head AND MD.DescId = zc_MovementDate_StartSale()))
                          || ' �� '              || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_2_Head AND MD.DescId = zc_MovementDate_EndSale()))
                    ELSE '��� �������������� ����������'
               END :: TVarChar
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN -1 -- zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN -1 -- zc_Color_Pink()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Pink()
                   ELSE -1
              END AS Color_Text

      UNION ALL
       -- 2.1.
       SELECT CASE WHEN vbCount_1_Main > 0
                        THEN vbMovementId_1_Main
                   WHEN vbCount_2_Main > 0
                        THEN vbMovementId_2_Main
                   ELSE -1
              END :: Integer AS MovementId

            , CASE WHEN vbIsUserSigning2 = TRUE THEN 1 ELSE 3 END :: Integer AS NPP
            , '��������������� ��������� : ' :: TVarChar AS MsgAddr
            , (CASE WHEN vbCount_1_Main > 0
                        THEN '������������ ���������� ��� ���������� '
                          || ' : '    || vbCount_1_Main :: TVarChar || ' ��.'
                          || COALESCE ((SELECT ' <' || MIS.ValueData || '>' FROM MovementItem AS MI JOIN MovementItemString AS MIS ON MIS.MovementItemId = MI.Id AND MIS.DescId = zc_MIString_Comment() AND MIS.ValueData <> '' WHERE MI.MovementId = vbMovementId_1_Main AND MI.DescId = zc_MI_Message() AND MI.ObjectId = zc_Enum_PromoStateKind_Main() AND MI.isErased = FALSE ORDER BY MI.Id DESC LIMIT 1), '')
                          || '    � ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_1_Main)
                          || ' �� '   || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_1_Main))
                          || ' ������ ������ � ' || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_1_Main AND MD.DescId = zc_MovementDate_StartSale()))
                          || ' �� '              || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_1_Main AND MD.DescId = zc_MovementDate_EndSale()))
                    ELSE '��� ������������ ����������'
               END :: TVarChar
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_1_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Black()
                   WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_1_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Lime()
                   WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Aqua()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_1_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_1_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Lime()
                   ELSE -1
              END AS Color_Text

      UNION ALL
       -- 2.2.
       SELECT CASE WHEN vbCount_2_Main > 0
                        THEN vbMovementId_2_Main
                   ELSE -1
              END :: Integer AS MovementId

            , CASE WHEN vbIsUserSigning2 = TRUE THEN 2 ELSE 4 END :: Integer AS NPP
            , '' :: TVarChar AS MsgAddr
            , (CASE WHEN vbCount_2_Main > 0
                        THEN '������������ ��������� ��� ���������� '
                          || ' : '    || vbCount_2_Main :: TVarChar || ' ��.'
                          || COALESCE ((SELECT ' <' || MIS.ValueData || '>' FROM MovementItem AS MI JOIN MovementItemString AS MIS ON MIS.MovementItemId = MI.Id AND MIS.DescId = zc_MIString_Comment() AND MIS.ValueData <> '' WHERE MI.MovementId = vbMovementId_2_Main AND MI.DescId = zc_MI_Message() AND MI.ObjectId = zc_Enum_PromoStateKind_Main() AND MI.isErased = FALSE ORDER BY MI.Id DESC LIMIT 1), '')
                          || '    � ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_2_Main)
                          || ' �� '   || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_2_Main))
                          || ' ������ ������ � ' || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_2_Main AND MD.DescId = zc_MovementDate_StartSale()))
                          || ' �� '              || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_2_Main AND MD.DescId = zc_MovementDate_EndSale()))
                    ELSE '��� �������������� ����������'
               END :: TVarChar
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN -1 -- zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN -1 -- zc_Color_Aqua()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE)
                        THEN zc_Color_Aqua()
                   ELSE -1
              END AS Color_Text
      
       ORDER BY 2
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.06.20                                        * add EnumName
*/

-- SELECT * FROM gpSelect_Object_GlobalMsg ('', zfCalc_UserAdmin())
