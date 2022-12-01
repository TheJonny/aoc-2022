const std = @import("std");

pub fn main() anyerror!void {
    var max: u64 = 0;
    const stdin = std.io.getStdIn();
    var eof = false;
    var arr = [4]u64{0,0,0,0};
    while (!eof) {
        var cals :u64 = 0;
        while (true) {
            var line_buf: [20]u8 = undefined;
            const amt = try stdin.read(&line_buf);
            if (amt == 0) {
                eof = true;
                break;
            }
            if (amt == line_buf.len) {
                return;
            }
            const line = std.mem.trimRight(u8, line_buf[0..amt], "\r\n");

            if (line.len == 0) {
                break;
            }
    

            const item = try std.fmt.parseUnsigned(u64, line, 10);
            cals += item;
        }
        arr[3] = cals;
        std.sort.sort(u64, arr[0..], void{}, comptime std.sort.desc(u64));
        
        if (cals >= max) {
            max = cals;
        }
    }
    std.log.info("Array: {any}", .{arr});
    var sum: u64 = 0;
    for (arr[0..3]) |x| {
        sum += x;
    }
    
    std.log.info("Sum: {any}", .{sum});
    
}
