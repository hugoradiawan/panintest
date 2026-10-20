architecture yang di gunakan adalah mvc.

model -> page (view) -> controller

untuk isu concurrency saya mengunakan system flaging.
ketika system transfering berjalan, system meng-flag busy.
ketika system transfering selesai, system meng-flag selesai.

untuk shuffling saya mengunakan list dari integer
dari 0 sampai 9. lalu mengunakan function .shuffle().
lalu saya siapkan layout untuk custom pin, lalu saya assign integer-
integer tersebut layout yang tersedia.