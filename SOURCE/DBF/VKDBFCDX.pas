{Copyright:      Vlad Karpov
 		 mailto:KarpovVV@protek.ru
		 http:\\vlad-karpov.narod.ru
     ICQ#136489711
 Author:         Vlad Karpov
 Remarks:        Freeware with pay for support, see license.txt
}
unit VKDBFCDX;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  db, VKDBFParser, DBCommon, VKDBFIndex;

const
  CDX_HEADER_SIZE = 1024;
  CDX_BUFFER_SIZE = 512;
  DATA_POOL_SIZE = CDX_BUFFER_SIZE - 12;          //500
  COMPACT_DATA_POOL_SIZE = CDX_BUFFER_SIZE - 24;  //488

type

  CDX_HEADER = packed Record
    root:       DWord;    {byte offset to root node}                    //0     4
    next_page:  DWord;    {byte offset to next free block               //4     4
                            (-1 if not present)}
    version:    DWord;    {Increments on modification}                  //8     4
    key_size:   Word;     {length of key}                               //12    2
    options:    Byte;     {bit field:                                   //14    1
                            1   unique
                            8   FOR clause
                            32  compact index
                            64  compound index}
    signature:  Byte;                                                   //15    1
    reserve0:   array [0..477] of Byte;                                 //16    478
    charset:    array [0..7] of AnsiChar;                                   //494   8
    desc:       Word;     {0 = ascending; 1=descending}                 //502   2
    reserve1:   Word;                                                   //504   2
    for_len:    Word;     {length of FOR clause}                        //506   2
    reserve2:   Word;                                                   //508   2
    key_len:    Word;     {length of index expression}                  //510   2
    key_pool:   array[0..pred(CDX_BUFFER_SIZE)] of AnsiChar;                //512   512
  end;                                                                  //1024
  pCDX_HEADER = ^CDX_HEADER;

  CDX_BUFFER  = packed Record
    attribute:  Word;   {Node attribute (any of the                     //0     2
                        following numeric values or
                        their sums):
                          0 – index node
                          1 – root node
                          2 – leaf node }
    count:      Word;   {Number of keys present                         //2     2
                        (0, 1 or many)}
    left:       DWord;  {Pointer to node directly to left               //4     4
                        of current node (on same level,
                        -1 if not present)}
    right:      DWord;  {Pointer to node directly to right              //8     4
                        of current node (on same level;
                        -1 if not present)}
    case Byte of                                                        //12
      0:(
        free_space:   Word;   {free space in compact_data}              //12    2
        rec_no_msk:   DWord;  {bit mask for record number}              //14    4
        dup_cnt_msk:  Byte;   {bit mask for duplicate byte count}       //18    1
        trl_cnt_msk:  Byte;   {bit mask for trailing bytes count}       //19    1
        rec_no_cntb:  Byte;   {num bits used for record number}         //20    1
        dup_cntb:     Byte;   {num bits used for duplicate count}       //21    1
        trl_cntb:     Byte;   {num bits used for trail count}           //22    1
        cnt_bytes:    Byte;   {bytes needed for recno+dups+trail}       //23    1
        compact_data:         {Data pool for compact recno+dups+trail}  //24    488
          array [0..pred(COMPACT_DATA_POOL_SIZE)] of AnsiChar;
        );
      1:(
        data_pool:            {Data pool for recno+key}                 //12    500
          array [0..pred(DATA_POOL_SIZE)] of AnsiChar;
        );
  end;                                                                  //512
  pCDX_BUFFER = ^CDX_BUFFER;

  {TVKCDXOrder}
  TVKCDXOrder = class(TVKDBFOrder)
  end;

  {TVKCDXBag}
  TVKCDXBag = class(TVKDBFIndexBag)
  end;

  {TVKCDXIndex}
  TVKCDXIndex = class(TIndex)
  end;

implementation

uses
   VKDBFDataSet;

end.
