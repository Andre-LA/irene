return {
  add_path = {
    '../', -- irene
    '../nene/bindings/nelua', -- nene
    '../rotor-nelua', -- rotor
  },
  cflags = '-I..//nene/include',
  ldflags = '-L..//nene/build',
}