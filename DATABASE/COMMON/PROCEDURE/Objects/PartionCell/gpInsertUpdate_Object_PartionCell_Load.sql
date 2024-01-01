 -- Function: gpInsertUpdate_Object_PartionCell_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartionCell_Load (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartionCell_Load(
    IN inName_l1    TVarChar    , 
    IN inName_l2    TVarChar    , 
    IN inName_l3    TVarChar    ,
    IN inName_l4    TVarChar    , 
    IN inName_l5    TVarChar    , 
    IN inName_l6    TVarChar    ,
    IN inSession    TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionCellId Integer;
   
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!������ ��� - ����������!!!
     IF COALESCE (inName_l1, '') = '' THEN
        RETURN; -- !!!�����!!!
     END IF;
   
     -- ������� 1  
     IF COALESCE (inName_l1, '') <> '' THEN
         -- !!!����� �� ������!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                                 INNER JOIN ObjectFloat AS ObjectFloat_Level
                                                        ON ObjectFloat_Level.ObjectId = Object.Id
                                                       AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()
                                                       AND ObjectFloat_Level.ValueData = 1
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inName_l1))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --���� ���� ������ �� ������, ���� ��� ����� �������� ����� �������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
            PERFORM gpInsertUpdate_Object_PartionCell( ioId          := 0 :: Integer
                                                     , inCode        := lfGet_ObjectCode(0, zc_Object_PartionCell()) :: Integer
                                                     , inName        := TRIM (inName_l1) :: TVarChar
                                                     , inLevel       := 1         :: TFloat
                                                     , inLength      := 0         :: TFloat
                                                     , inWidth       := 0         :: TFloat
                                                     , inHeight      := 0         :: TFloat
                                                     , inBoxCount    := 0         :: TFloat
                                                     , inRowBoxCount := 0         :: TFloat
                                                     , inRowWidth    := 0         :: TFloat
                                                     , inRowHeight   := 0         :: TFloat
                                                     , inComment     := NULL      :: TVarChar
                                                     , inSession     := inSession :: TVarChar 
                                                     );
         END IF;
         
     END IF;
     
     -- ������� 2  
     IF COALESCE (inName_l2, '') <> '' THEN
         -- !!!����� �� ������!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                                 INNER JOIN ObjectFloat AS ObjectFloat_Level
                                                        ON ObjectFloat_Level.ObjectId = Object.Id
                                                       AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()
                                                       AND ObjectFloat_Level.ValueData = 2
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inName_l2))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --���� ���� ������ �� ������, ���� ��� ����� �������� ����� �������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
            PERFORM gpInsertUpdate_Object_PartionCell( ioId          := 0 :: Integer
                                                     , inCode        := lfGet_ObjectCode(0, zc_Object_PartionCell()) :: Integer
                                                     , inName        := TRIM (inName_l2)   :: TVarChar
                                                     , inLevel       := 2         :: TFloat
                                                     , inLength      := 0         :: TFloat
                                                     , inWidth       := 0         :: TFloat
                                                     , inHeight      := 0         :: TFloat
                                                     , inBoxCount    := 0         :: TFloat
                                                     , inRowBoxCount := 0         :: TFloat
                                                     , inRowWidth    := 0         :: TFloat
                                                     , inRowHeight   := 0         :: TFloat
                                                     , inComment     := NULL      :: TVarChar
                                                     , inSession     := inSession :: TVarChar
                                                     ); 
         END IF;
         
     END IF;

     -- ������� 3 
     IF COALESCE (inName_l3, '') <> '' THEN
         -- !!!����� �� ������!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                                 INNER JOIN ObjectFloat AS ObjectFloat_Level
                                                        ON ObjectFloat_Level.ObjectId = Object.Id
                                                       AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()
                                                       AND ObjectFloat_Level.ValueData = 3
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inName_l3))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --���� ���� ������ �� ������, ���� ��� ����� �������� ����� �������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
            PERFORM gpInsertUpdate_Object_PartionCell( ioId          := 0 :: Integer
                                                     , inCode        := lfGet_ObjectCode(0, zc_Object_PartionCell()) :: Integer
                                                     , inName        := TRIM (inName_l3)                      :: TVarChar
                                                     , inLevel       := 3         :: TFloat
                                                     , inLength      := 0         :: TFloat
                                                     , inWidth       := 0         :: TFloat
                                                     , inHeight      := 0         :: TFloat
                                                     , inBoxCount    := 0         :: TFloat
                                                     , inRowBoxCount := 0         :: TFloat
                                                     , inRowWidth    := 0         :: TFloat
                                                     , inRowHeight   := 0         :: TFloat
                                                     , inComment     := NULL      :: TVarChar
                                                     , inSession     := inSession :: TVarChar
                                                     ); 
         END IF;
         
     END IF;

     -- ������� 4  
     IF COALESCE (inName_l4, '') <> '' THEN
         -- !!!����� �� ������!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                                 INNER JOIN ObjectFloat AS ObjectFloat_Level
                                                        ON ObjectFloat_Level.ObjectId = Object.Id
                                                       AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()
                                                       AND ObjectFloat_Level.ValueData = 4
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inName_l4))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --���� ���� ������ �� ������, ���� ��� ����� �������� ����� �������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
            PERFORM gpInsertUpdate_Object_PartionCell( ioId          := 0 :: Integer
                                                     , inCode        := lfGet_ObjectCode(0, zc_Object_PartionCell()) :: Integer
                                                     , inName        := TRIM (inName_l4)                      :: TVarChar
                                                     , inLevel       := 4         :: TFloat
                                                     , inLength      := 0         :: TFloat
                                                     , inWidth       := 0         :: TFloat
                                                     , inHeight      := 0         :: TFloat
                                                     , inBoxCount    := 0         :: TFloat
                                                     , inRowBoxCount := 0         :: TFloat
                                                     , inRowWidth    := 0         :: TFloat
                                                     , inRowHeight   := 0         :: TFloat
                                                     , inComment     := NULL      :: TVarChar
                                                     , inSession     := inSession :: TVarChar
                                                     ); 
         END IF;
         
     END IF;


     -- ������� 5  
     IF COALESCE (inName_l5, '') <> '' THEN
         -- !!!����� �� ������!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                                 INNER JOIN ObjectFloat AS ObjectFloat_Level
                                                        ON ObjectFloat_Level.ObjectId = Object.Id
                                                       AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()
                                                       AND ObjectFloat_Level.ValueData = 5
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inName_l5))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --���� ���� ������ �� ������, ���� ��� ����� �������� ����� �������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
            PERFORM gpInsertUpdate_Object_PartionCell( ioId          := 0 :: Integer
                                                     , inCode        := lfGet_ObjectCode(0, zc_Object_PartionCell()) :: Integer
                                                     , inName        := TRIM (inName_l5)                      :: TVarChar
                                                     , inLevel       := 5         :: TFloat
                                                     , inLength      := 0         :: TFloat
                                                     , inWidth       := 0         :: TFloat
                                                     , inHeight      := 0         :: TFloat
                                                     , inBoxCount    := 0         :: TFloat
                                                     , inRowBoxCount := 0         :: TFloat
                                                     , inRowWidth    := 0         :: TFloat
                                                     , inRowHeight   := 0         :: TFloat
                                                     , inComment     := NULL      :: TVarChar
                                                     , inSession     := inSession :: TVarChar 
                                                     );
         END IF;
         
     END IF;

     -- ������� 6  
     IF COALESCE (inName_l6, '') <> '' THEN
         -- !!!����� �� ������!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                                 INNER JOIN ObjectFloat AS ObjectFloat_Level
                                                        ON ObjectFloat_Level.ObjectId = Object.Id
                                                       AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()
                                                       AND ObjectFloat_Level.ValueData = 6
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inName_l6))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --���� ���� ������ �� ������, ���� ��� ����� �������� ����� �������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
            PERFORM gpInsertUpdate_Object_PartionCell( ioId          := 0 :: Integer
                                                     , inCode        := lfGet_ObjectCode(0, zc_Object_PartionCell()) :: Integer
                                                     , inName        := TRIM (inName_l6)                      :: TVarChar
                                                     , inLevel       := 6         :: TFloat
                                                     , inLength      := 0         :: TFloat
                                                     , inWidth       := 0         :: TFloat
                                                     , inHeight      := 0         :: TFloat
                                                     , inBoxCount    := 0         :: TFloat
                                                     , inRowBoxCount := 0         :: TFloat
                                                     , inRowWidth    := 0         :: TFloat
                                                     , inRowHeight   := 0         :: TFloat
                                                     , inComment     := NULL      :: TVarChar
                                                     , inSession     := inSession :: TVarChar 
                                                     );
         END IF;
         
     END IF;




END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.12.23         *
*/

-- ����
--

