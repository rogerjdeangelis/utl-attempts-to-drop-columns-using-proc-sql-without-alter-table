%let pgm=utl-attempts-to-drop-columns-using-proc-sql-without-alter-table;

Attempts to drop columns using proc sql without alter table

Purely and academic exercise, no for production.

github
https://tinyurl.com/2cvwu3y9
https://github.com/rogerjdeangelis/utl-attempts-to-drop-columns-using-proc-sql-without-alter-table

Interesting properties of SQL

If I could rename the second occurance I this we would
have a way to drop duplicate columns.

   CONTENTS

      1 MULTIPLE COLUMNS WITH THE SAME NAME
      2 DROP COLUMN WEIGHT (IF WEIGHT IS ALL 0s)
      3 PROC CONTENTS
      4 SQL DICTIONARY
      5 REMOVE SECOND OCCURANCE


      1. MULTIPLE COLUMNS WITH THE SAME NAME

         proc sql;
           select
              name
             ,height
             ,height
           from
             sashelp.class(obs=3)
         ;quit;

         DUPLICATED COLUMN

         NAME        HEIGHT    HEIGHT
         ----------------------------
         Alfred          69        69
         Alice         56.5      56.5
         Barbara       65.3      65.3

         When you have repeated names the sas and
         datset tables use the first occurance?


     2   DROP COLUMN WEIGHT IF ALL 0s

         INPUT

          NAME      HEIGHT    WEIGHT

         Alfred      69.0        0
         Alice       56.5        0
         Barbara     65.3        0

         PROCESS

         data sd1.have;
           set sashelp.class(obs=3);
           weight=0;
         run;quit;

         * if  sum(WEIGHT)=0 then put out a second HEIGHT column
           which automatically goes away down stream;

         proc sql;
           create
              view duo as
           select
              name
             ,height
             ,ifn(sum(WEIGHT)=0,HEIGHT,WEIGHT) as HEIGHT
           from
             sd1.have
         ;quit;

          OUTPUT

      3   FROM PROC CONTENTS (NOTE WEIGHT HAS BEEN DROPPED)

          Variables in Creation Order

          Variable    Type    Len    Flags

          NAME        Char      8    ---
          HEIGHT      Num       8    -C-   C ???
          HEIGHT      Num       8    P--   Protected cannot be updated

          DUO VIEW  (PROBLEM GOES AWAY IN FUTHER PROCESSING)

          Obs     NAME      HEIGHT    HEIGHT

            1    Alfred      69.0      69.0
            2    Alice       56.5      56.5
            3    Barbara     65.3      65.3

      3   FROM PROC CONTENTS (NOTE WEIGHT HAS BEEN DROPPED)

          proc sql;
            create
              view vduo as
            select
              *
            from
              sashelp.vcolumn
            where
                  libname="WORK"
              and memname="VDUO"
          ;quit;


            -- CHARACTER --
           Variable       Typ    Value   Label

           LIBNAME         C8            Library Name
           MEMNAME         C32           Member Name
           MEMTYPE         C8            Member Type
           NAME            C32           Column Name
           TYPE            C4            Column Type
           LABEL           C256          Column Label
           FORMAT          C49           Column Format
           INFORMAT        C49           Column Informat
           IDXUSAGE        C9            Column Index Type
           XTYPE           C12           Extended Type
           NOTNULL         C3            Not NULL?
           TRANSCODE       C3            Transcoded?
           TOTOBS          C16   3       TOTOBS


            -- NUMERIC -
           LENGTH          N8            Column Length
           NPOS            N8            Column Position
           VARNUM          N8            Column Number in Table
           SORTEDBY        N8            Order in Key Sequence
           PRECISION       N8            Precision
           SCALE           N8            Scale


       4  proc datasets lib=work;
          contents data=vduo;
          run;quit;

          NAME         Char     32    P--      Column Name

          FORMAT       Char     49    P--      Column Format
          IDXUSAGE     Char      9    P--      Column Index Type
          INFORMAT     Char     49    P--      Column Informat
          LABEL        Char    256    P--      Column Label
          LENGTH       Num       8    P--      Column Length
          LIBNAME      Char      8    P--      Library Name
          MEMNAME      Char     32    P--      Member Name
          MEMTYPE      Char      8    P--      Member Type
          NOTNULL      Char      3    P--      Not NULL?
          NPOS         Num       8    P--      Column Position
          PRECISION    Num       8    P--      Precision
          SCALE        Num       8    P--      Scale
          SORTEDBY     Num       8    P--      Order in Key Sequence
          TRANSCODE    Char      3    P--      Transcoded?
          TYPE         Char      4    P--      Column Type
          VARNUM       Num       8    P--      Column Number in Table
          XTYPE        Char     12    P--      Extended Type

       5  REMOVE SECOND OCCURANCE

          data gone;
            set duo;
          run;quit;


           NAME      HEIGHT

          Alfred      69.0
          Alice       56.5
          Barbara     65.3

          #    Variable    Type    Len

          1    NAME        Char      8
          2    HEIGHT      Num       8

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
