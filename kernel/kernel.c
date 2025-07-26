void kernel_main() {
    // Video belleği adresi 0xb8000'dir.
    char* video_memory = (char*) 0xb8000;

    // Ekrana beyaz zemin üzerine mavi 'K' harfi yaz.
    // İlk byte karakter, ikinci byte renk kodudur.
    video_memory[0] = 'K';
    video_memory[1] = 0x1F; // 1 = Mavi, F = Parlak Beyaz zemin
}