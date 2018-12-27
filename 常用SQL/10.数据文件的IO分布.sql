/*数据文件的I/O分布  */
  SELECT   df.name,
           phyrds,
           phywrts,
           phyblkrd,
           phyblkwrt,
           singleblkrds,
           readtim,
           writetim
    FROM   v$filestat fs, v$dbfile df
   WHERE   fs.file# = df.file#
ORDER BY   df.name;