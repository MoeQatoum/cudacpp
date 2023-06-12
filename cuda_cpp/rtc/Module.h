#pragma once

#include "../CudaContext.h"
#include "Program.h"

namespace cudacpp {
  namespace rtc {

    class Module {
      CUmodule _module;

    public:
      Module(const CudaContext&, const Program& p) { cuModuleLoadDataEx(&_module, p.PTX().c_str(), 0, 0, 0); }

      auto module() const { return _module; }
    };

  } // namespace rtc
} // namespace cudacpp
