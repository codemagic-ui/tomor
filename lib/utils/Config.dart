import 'dart:core';

class Config {
  static String strBaseURL = "https://tomoronline.com/api/";
  static String token =
      "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE1ODA2NDAxNDcsImV4cCI6MTg5NjAwMDE0NywiaXNzIjoiaHR0cHM6Ly90b21vcm9ubGluZS5jb20iLCJhdWQiOlsiaHR0cHM6Ly90b21vcm9ubGluZS5jb20vcmVzb3VyY2VzIiwibm9wX2FwaSJdLCJjbGllbnRfaWQiOiJiNDIxZGE2Zi1hY2IyLTRhODAtYTJlNi0xNTUzYjY2ODcwZWMiLCJzdWIiOiJiNDIxZGE2Zi1hY2IyLTRhODAtYTJlNi0xNTUzYjY2ODcwZWMiLCJhdXRoX3RpbWUiOjE1ODA2NDAxNDQsImlkcCI6ImxvY2FsIiwic2NvcGUiOlsibm9wX2FwaSIsIm9mZmxpbmVfYWNjZXNzIl0sImFtciI6WyJwd2QiXX0.Jy23Q2wNdDqDTAcZ-P6ztKZlJPNCNizzBPmmv6wFuLg7DHbctka9N0pUh2vBTNBTRQ-DC1y64qqtbg9QgXzNB1UPDdJ55vtllAKZIPndco0wG7s_S6FcVPt4qOWoXuo40FsN7IB6WM3oJEnID6E6u1779tfElCnUklLGe7rIbohPCfOjAYWeJ5HhPM5dIZj3hyMtDY3Z6E4mwWC5L9TZ2RqBh6DcGFhoPpxGRgWdnPyfmvv-4s7zQOwjZwAsn4Ni2OZRSACbr9ZEsQcbK5wz4XO6ruNlcee2D4bUSUnLp0f83A-1gAPMj_vw6h_0ppNCayl098k_blh-LD-6vfXJiA";

  static var httpGetHeader = {"Authorization": token};

  static var httpPostHeader = {
    "Authorization": token,
    "Accept": "application/json",
    "Content-type": "application/json"
  };

  static var httpPostHeaderForEncode = {
    "Authorization": token,
    "Accept": "application/json",
    "Content-type": "application/x-www-form-urlencoded"
  };
}
